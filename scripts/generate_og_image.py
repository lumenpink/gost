#!/usr/bin/env python3
"""
Gera o banner de compartilhamento Open Graph / Twitter Card (1200x630 pixels)
para a especificação GOST em estrita conformidade com o Capítulo 11 da norma:
- Resolução 1200x630 pixels.
- Safe Zone 4:3 no miolo centralizado (anti-recorte WhatsApp e mobile).
- Tipografia geométrica e nítida.
- Identidade visual técnica e construtivista.
"""

import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

W, H = 1200, 630
MARGIN = 80

# Paleta Técnica / Gosplan
C_BG_DEEP     = (13, 17, 23, 255)       # Chassis profundo
C_BG_PANEL    = (22, 27, 34, 255)       # Superfície técnica
C_GRID        = (48, 54, 61, 80)        # Linhas de grade blueprint
C_RED         = (230, 57, 70, 255)      # Carmesim soviético
C_GOLD        = (255, 183, 3, 255)      # Dourado técnico Gosplan
C_TEXT_WHITE  = (240, 246, 252, 255)    # Branco puro
C_TEXT_MUTED  = (139, 148, 158, 220)    # Cinza técnico
C_BORDER      = (48, 54, 61, 200)

FONT_BOLD_CANDIDATES = [
    "/usr/share/fonts/truetype/firacode/FiraCode-Bold.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
]

FONT_REG_CANDIDATES = [
    "/usr/share/fonts/truetype/firacode/FiraCode-Regular.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
]

def get_font(candidates, size):
    for path in candidates:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    return ImageFont.load_default()

def draw_centered_text(draw, y, text, font, fill, shadow=None, shadow_offset=2):
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    x = (W - tw) // 2
    if shadow:
        draw.text((x + shadow_offset, y + shadow_offset), text, font=font, fill=shadow)
    draw.text((x, y), text, font=font, fill=fill)
    return x, y, tw, bbox[3] - bbox[1]

def create_og_image(output_path="site/assets/og_preview.png"):
    base = Image.new("RGBA", (W, H), C_BG_DEEP)
    draw = ImageDraw.Draw(base)

    # 1. Blueprint Grid & Texturas Técnicas
    grid_size = 32
    for x in range(0, W, grid_size):
        draw.line([(x, 0), (x, H)], fill=C_GRID, width=1)
    for y in range(0, H, grid_size):
        draw.line([(0, y), (W, y)], fill=C_GRID, width=1)

    # 2. Glow Ambiental Central
    glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    gdraw.ellipse([320, 100, 880, 500], fill=(230, 57, 70, 30))
    gdraw.ellipse([420, 160, 780, 440], fill=(255, 183, 3, 20))
    glow = glow.filter(ImageFilter.GaussianBlur(95))
    base = Image.alpha_composite(base, glow)
    draw = ImageDraw.Draw(base)

    # 3. Carregar Fontes
    f_badge = get_font(FONT_BOLD_CANDIDATES, 15)
    f_brand = get_font(FONT_BOLD_CANDIDATES, 88)
    f_cyril = get_font(FONT_BOLD_CANDIDATES, 32)
    f_title = get_font(FONT_BOLD_CANDIDATES, 32)
    f_sub   = get_font(FONT_REG_CANDIDATES, 22)
    f_tag   = get_font(FONT_BOLD_CANDIDATES, 14)
    f_foot  = get_font(FONT_BOLD_CANDIDATES, 19)
    f_meta  = get_font(FONT_REG_CANDIDATES, 17)

    # 4. Top Accent Lines
    draw.line([(0, 0), (W, 0)], fill=C_RED, width=4)
    draw.line([(0, 3), (W, 3)], fill=C_GOLD, width=2)

    # 5. Badge Superior no Miolo Central
    badge_text = "  ★ NORMA TÉCNICA ABERTA  //  GOST v1.1.0  //  CC-BY-SA-4.0  "
    bbox_b = draw.textbbox((0, 0), badge_text, font=f_badge)
    bw = bbox_b[2] - bbox_b[0]
    bh = bbox_b[3] - bbox_b[1]
    bx = (W - bw) // 2
    by = 52
    draw.rectangle([bx - 14, by - 6, bx + bw + 14, by + bh + 6], fill=(18, 22, 30, 230), outline=C_GOLD, width=1)
    draw.text((bx, by), badge_text, font=f_badge, fill=C_GOLD)

    # 6. Hero Brand: "ГОСТ / GOST"
    brand_y = 125
    brand_text = "ГОСТ  ·  GOST"
    bbox_br = draw.textbbox((0, 0), brand_text, font=f_brand)
    brw = bbox_br[2] - bbox_br[0]
    brx = (W - brw) // 2

    # Sombra brutalista em carmesim
    for ox, oy, alpha in [(4, 4, 180), (2, 2, 120)]:
        draw.text((brx + ox, brand_y + oy), brand_text, font=f_brand, fill=(230, 57, 70, alpha))
    draw.text((brx, brand_y), brand_text, font=f_brand, fill=C_TEXT_WHITE)

    # Linha divisória geométrica sob a marca
    bar_y = brand_y + (bbox_br[3] - bbox_br[1]) + 18
    bar_w = 740
    bar_x = (W - bar_w) // 2
    draw.line([(bar_x, bar_y), (bar_x + bar_w, bar_y)], fill=C_RED, width=2)
    # Detalhe central dourado na linha
    draw.line([(bar_x + (bar_w // 2) - 40, bar_y), (bar_x + (bar_w // 2) + 40, bar_y)], fill=C_GOLD, width=2)

    # 7. Título e Subtítulo Centralizados na Safe Zone
    t_y = bar_y + 24
    draw_centered_text(draw, t_y, "Arquitetura Soberana & DD-TDD de Repositórios", f_title, C_TEXT_WHITE,
                       shadow=(0, 0, 0, 220), shadow_offset=2)

    s_y = t_y + 48
    draw_centered_text(draw, s_y, "Hermeticidade, CI Hermético, Portas & Adaptadores e Governança Pública", f_sub, C_GOLD)

    # 8. Tags de Conformidade
    tags = ["REPOSITÓRIO ANATOMIA", "TESTES DETERMINÍSTICOS", "METADADOS SOCIAIS 4:3", "GOSPLAN CI"]
    tag_total_w = sum(draw.textbbox((0, 0), f"[ {t} ]", font=f_tag)[2] for t in tags) + (len(tags) - 1) * 16
    tx = (W - tag_total_w) // 2
    ty = s_y + 54

    for t in tags:
        label = f"[ {t} ]"
        lbox = draw.textbbox((0, 0), label, font=f_tag)
        lw = lbox[2] - lbox[0]
        lh = lbox[3] - lbox[1]
        draw.rectangle([tx - 6, ty - 4, tx + lw + 6, ty + lh + 4], fill=C_BG_PANEL, outline=C_BORDER, width=1)
        draw.text((tx, ty), label, font=f_tag, fill=C_TEXT_MUTED)
        tx += lw + 16

    # 9. Rodapé no Miolo Central (largura 780px)
    foot_y = H - 85
    f_bar_w = 780
    f_bar_x = (W - f_bar_w) // 2
    draw.line([(f_bar_x, foot_y - 16), (f_bar_x + f_bar_w, foot_y - 16)], fill=C_BORDER, width=1)

    # LED verde de status
    draw.ellipse([f_bar_x, foot_y + 4, f_bar_x + 14, foot_y + 18], fill=(63, 185, 80, 255))
    draw.text((f_bar_x + 24, foot_y), "gost.2lp.in", font=f_foot, fill=C_GOLD)

    # Créditos na direita do miolo
    cred_text = "CCCP Comrades · Lumen Pink · 100% Livre"
    cbox = draw.textbbox((0, 0), cred_text, font=f_meta)
    draw.text((f_bar_x + f_bar_w - (cbox[2] - cbox[0]), foot_y + 2), cred_text, font=f_meta, fill=C_TEXT_MUTED)

    # Borda decorativa inferior
    draw.line([(0, H - 3), (W, H - 3)], fill=C_GOLD, width=3)
    draw.line([(0, H - 1), (W, H - 1)], fill=C_RED, width=1)

    # 10. Salvar PNG
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    final = base.convert("RGB")
    final.save(output_path, format="PNG", optimize=True)
    
    # Cópia em poster.png
    poster_path = os.path.join(os.path.dirname(output_path), "poster.png")
    final.save(poster_path, format="PNG", optimize=True)
    
    kb = os.path.getsize(output_path) / 1024
    print(f"✅ Card Open Graph gerado com sucesso: {output_path} ({W}x{H}, {kb:.1f} KB)")
    print(f"✅ Cópia para pôster gerada: {poster_path}")

if __name__ == "__main__":
    create_og_image()
