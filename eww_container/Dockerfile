FROM kalilinux/kali-rolling

# Evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
RUN apt update && apt install -y \
    git build-essential pkg-config \
    libgtk-3-dev libpango1.0-dev libglib2.0-dev libcairo2-dev \
    libdbusmenu-glib-dev libdbusmenu-gtk3-dev \
    libgtk-layer-shell-dev \
    libx11-dev libxft-dev libxrandr-dev libxtst-dev \
    meson ninja-build libwayland-dev wayland-protocols \
    curl ca-certificates gobject-introspection

# Instalar Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Clonar y compilar EWW
RUN cd /root && \
    git clone https://github.com/elkowar/eww.git && \
    cd eww && \
    cargo build --release && \
    cp target/release/eww /usr/bin/

# Crear usuario no privilegiado
RUN useradd -m eww_user && \
    mkdir -p /home/eww_user/.config/eww && \
    chown -R eww_user:eww_user /home/eww_user/.config

# Copiar configuración local (./eww) al directorio del usuario
COPY ./eww /home/eww_user/.config/eww/
RUN chown -R eww_user:eww_user /home/eww_user/.config/eww

# Cambiar al usuario no root
USER eww_user
WORKDIR /home/eww_user

# Comando para ejecutar EWW al iniciar el contenedor
ENTRYPOINT ["/bin/bash", "-c", "eww daemon && tail -f /dev/null"]
