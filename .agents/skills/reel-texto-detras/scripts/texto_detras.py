# Efecto "texto detrás de la persona" para reels verticales (1080x1920):
# palabras gigantes verde neón que entran con eco, quedan DETRÁS de la cabeza (recorte IA),
# palabra vertical gigante, subtítulos pequeños y logo de marca de agua.
#
# Uso:  python texto_detras.py plan.json
# plan.json (tiempos en segundos del clip):
# {
#   "video": "host.mp4",            # clip vertical del presentador (ideal 3-10 s; el recorte IA va a ~1.3 cuadros/s)
#   "persona": "persona.webm",      # opcional; si no existe se crea con hyperframes remove-background
#   "salida": "gancho.mp4",
#   "titulos": [
#     {"texto": "¿SABÍAS\nQUE", "t0": 0.8, "t1": 2.6, "y": 0.40},
#     {"texto": "TECNOLOGÍA\nCREATIVIDAD", "t0": 3.2, "t1": 5.0, "y": 0.22},
#     {"texto": "APRENDIZAJE", "t0": 5.2, "t1": 6.8, "vertical": true, "color": "#FFFFFF"}
#   ],
#   "subtitulos": true,             # transcribe con faster-whisper local y pone frases cortas pequeñas
#   "reemplazos": {"Tim": "Jen"},   # opcional: corrige nombres que Whisper oye mal
#   "logo": "logo.png",             # opcional, arriba a la derecha
#   "cierre": "logo.png"            # opcional: tarjeta blanca de 2.5 s con el logo al final
# }
import json, math, os, subprocess, sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFont

W, H, FPS = 1080, 1920, 30
FUENTE = "C:/Windows/Fonts/seguibl.ttf"   # Segoe UI Black, estirada a lo ancho imita la fuente "extended" del reel
FUENTE_SUB = "C:/Windows/Fonts/seguisb.ttf"
WHISPER_PY = Path.home() / "Documents/SabiasQue/06_Automatizacion/alineacion_local/.venv/Scripts/python.exe"
HF_CLI = Path.home() / ".claude/skills/hyperframes/scripts/plugin-cli.mjs"
NEON = (200, 255, 0)


def hexcol(s):
    return tuple(int(s.lstrip("#")[i:i + 2], 16) for i in (0, 2, 4))


def ease_out(u):  # expo: llega rápido y se frena (golpe)
    return 1 - 2 ** (-10 * min(max(u, 0), 1))


def bloque_texto(txt, tam, color, vertical=False, ancho=1.18):
    """renderiza el texto una vez (RGBA), estirado a lo ancho; vertical = rotado 90°"""
    f = ImageFont.truetype(FUENTE, tam)
    lineas = txt.split("\n")
    d0 = ImageDraw.Draw(Image.new("L", (1, 1)))
    lw = max(d0.textlength(l, font=f) for l in lineas)
    lh = int(tam * 0.92)
    im = Image.new("RGBA", (int(lw) + 20, lh * len(lineas) + int(tam * 0.3)), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    for i, l in enumerate(lineas):
        d.text(((im.width - d.textlength(l, font=f)) / 2, i * lh), l, font=f, fill=color + (255,))
    im = im.resize((int(im.width * ancho), im.height), Image.LANCZOS)
    im = im.rotate(90, expand=True) if vertical else im
    k = (0.9 * H / im.height) if vertical else (0.94 * W / im.width)  # ocupa toda la pantalla, como en el reel
    return im.resize((int(im.width * k), int(im.height * k)), Image.LANCZOS)


def capa_titulos(titulos, t):
    """capa RGBA con los títulos activos en el instante t (entrada con eco, salida con eco)"""
    capa = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    for ti in titulos:
        t0, t1, im = ti["t0"], ti["t1"], ti["_im"]
        if not (t0 <= t < t1 + 0.3):
            continue
        vert = ti.get("vertical", False)
        cx = W * ti.get("x", 0.09 if vert else 0.5)
        cy = H * ti.get("y", 0.5)

        def pos(tt):  # desplazamiento según el tiempo: entra desde un lado, sale hacia el otro
            if tt < t1:
                u = ease_out((tt - t0) / 0.35)
                off = (1 - u) * (1.1 * H if vert else -1.1 * W)
            else:
                u = ((tt - t1) / 0.3) ** 2
                off = u * (-1.1 * H if vert else 1.1 * W)
            return (cx, cy + off) if vert else (cx + off, cy)

        for k, alfa in ((4, 0.12), (3, 0.2), (2, 0.32), (1, 0.5), (0, 1.0)):  # eco: copias en instantes anteriores
            x, y = pos(t - k * 0.03)
            ghost = im if k == 0 else im.copy()
            if k:
                a = np.asarray(ghost).copy()
                a[..., 3] = (a[..., 3] * alfa).astype(np.uint8)
                ghost = Image.fromarray(a)
            capa.alpha_composite(ghost, (int(x - im.width / 2), int(y - im.height / 2)))
    return capa


def frases(palabras, max_pal=4):
    out, cur = [], []
    for w in palabras:
        cur.append(w)
        if len(cur) >= max_pal or w["w"].rstrip().endswith((".", ",", "?", "!")):
            out.append(cur); cur = []
    return out + ([cur] if cur else [])


def transcribir(video):
    code = ("import sys,json,subprocess,numpy as np\nfrom faster_whisper import WhisperModel\n"
            "a=np.frombuffer(subprocess.run(['ffmpeg','-v','error','-i',sys.argv[1],'-f','f32le','-ac','1','-ar','16000','-'],capture_output=True).stdout,np.float32)\n"
            "m=WhisperModel('base',device='cpu',compute_type='int8',download_root=sys.argv[2])\n"
            "s,_=m.transcribe(a,language='es',word_timestamps=True)\n"
            "print(json.dumps([{'w':w.word.strip(),'s':w.start,'e':w.end} for x in s for w in x.words]))")
    r = subprocess.run([str(WHISPER_PY), "-c", code, str(video), str(WHISPER_PY.parents[2] / "modelos")],
                       capture_output=True, text=True, encoding="utf-8", env={**os.environ, "HF_HOME": str(WHISPER_PY.parents[2] / "modelos")})
    if r.returncode:
        sys.exit("faster-whisper falló: " + r.stderr[-500:])
    return json.loads(r.stdout.strip().splitlines()[-1])


def subtitulo(im, grupos, t):
    for g in grupos:
        if g[0]["s"] - 0.05 <= t < g[-1]["e"] + 0.1:
            d = ImageDraw.Draw(im)
            f = ImageFont.truetype(FUENTE_SUB, 40)
            txt = " ".join(w["w"] for w in g)
            d.text((W / 2 + 3, H * 0.63 + 3), txt, font=f, fill=(0, 0, 0, 170), anchor="mm")  # sombra suave
            d.text((W / 2, H * 0.63), txt, font=f, fill=(255, 255, 255, 255), anchor="mm")
            return


def leer(cmd, n_bytes):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    while True:
        b = p.stdout.read(n_bytes)
        if len(b) < n_bytes:
            return
        yield b


def main():
    plan_p = Path(sys.argv[1]).resolve()
    plan = json.loads(plan_p.read_text(encoding="utf-8"))
    base = plan_p.parent
    video = base / plan["video"]
    persona = base / plan.get("persona", "persona.webm")
    salida = base / plan.get("salida", "gancho.mp4")
    if not persona.exists():  # recorte IA local (CPU): ~1.3 cuadros por segundo
        subprocess.run(["node", str(HF_CLI), "remove-background", str(video), "-o", str(persona)], check=True)
    for ti in plan["titulos"]:
        ti["_im"] = bloque_texto(ti["texto"], 200,
                                 hexcol(ti["color"]) if "color" in ti else NEON, ti.get("vertical", False))
    pal = transcribir(video) if plan.get("subtitulos") else []
    for w in pal:
        for mal, bien in plan.get("reemplazos", {}).items():
            w["w"] = w["w"].replace(mal, bien)
    grupos = frases(pal)
    logo = None
    if plan.get("logo"):
        logo = Image.open(base / plan["logo"]).convert("RGBA")
        logo = logo.resize((110, int(110 * logo.height / logo.width)), Image.LANCZOS)
    escala = f"scale={W}:{H}:force_original_aspect_ratio=increase,crop={W}:{H},fps={FPS}"
    fondo = leer(["ffmpeg", "-v", "error", "-i", str(video), "-vf", escala, "-f", "rawvideo", "-pix_fmt", "rgb24", "-"], W * H * 3)
    recorte = leer(["ffmpeg", "-v", "error", "-c:v", "libvpx-vp9", "-i", str(persona), "-vf", escala, "-f", "rawvideo", "-pix_fmt", "rgba", "-"], W * H * 4)
    tmp = salida.with_suffix(".sinaudio.mp4")
    enc = subprocess.Popen(["ffmpeg", "-v", "error", "-y", "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{W}x{H}", "-r", str(FPS), "-i", "-",
                            "-c:v", "libx264", "-crf", "18", "-pix_fmt", "yuv420p", str(tmp)], stdin=subprocess.PIPE)
    n = 0
    for fb, pb in zip(fondo, recorte):
        t = n / FPS
        im = Image.frombytes("RGB", (W, H), fb).convert("RGBA")
        im.alpha_composite(capa_titulos(plan["titulos"], t))          # 1) texto sobre el fondo
        im.alpha_composite(Image.frombytes("RGBA", (W, H), pb))       # 2) la persona encima: el texto queda detrás
        subtitulo(im, grupos, t)                                      # 3) subtítulos y logo por encima de todo
        if logo:
            im.alpha_composite(logo, (W - logo.width - 40, 60))
        enc.stdin.write(im.convert("RGB").tobytes())
        n += 1
    if plan.get("cierre"):  # tarjeta blanca con el logo que entra con rebote
        lg = Image.open(base / plan["cierre"]).convert("RGBA")
        for k in range(int(2.5 * FPS)):
            u = k / FPS
            s = 1 + 0.25 * math.sin(min(u / 0.4, 1) * math.pi) * (1 - min(u / 0.4, 1))
            w_ = int(420 * min(u / 0.25, 1) * s) or 1
            im = Image.new("RGBA", (W, H), (240, 240, 240, 255))
            l2 = lg.resize((w_, max(1, int(w_ * lg.height / lg.width))), Image.LANCZOS)
            im.alpha_composite(l2, ((W - l2.width) // 2, (H - l2.height) // 2))
            enc.stdin.write(im.convert("RGB").tobytes())
            n += 1
    enc.stdin.close(); enc.wait()
    # audio original del clip (silencio en la tarjeta de cierre)
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", str(tmp), "-i", str(video), "-map", "0:v", "-map", "1:a?", "-c:v", "copy",
                    "-c:a", "aac", "-b:a", "192k", "-af", "apad", "-shortest", "-movflags", "+faststart", str(salida)], check=True)
    tmp.unlink()
    print(f"listo: {salida} ({n / FPS:.1f} s)")


if __name__ == "__main__":
    main()
