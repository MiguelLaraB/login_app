# Usa una imagen de Flutter
FROM cirrusci/flutter:stable AS build

# Copia tu código Flutter al contenedor
COPY . .

# Establece el directorio de trabajo
WORKDIR /app

# Ejecuta la compilación en modo web
RUN flutter build web --release

# Fase de despliegue con Nginx para servir la app
FROM nginx:alpine

# Copia los archivos generados en la fase de construcción a la imagen de nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Exponer el puerto en el que Nginx estará sirviendo la aplicación
EXPOSE 80

# Comando por defecto para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
