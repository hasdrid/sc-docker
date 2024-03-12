# Use imgproxy base image
FROM darthsim/imgproxy:latest

# Set environment variables
ENV IMGPROXY_ONLY_PRESETS="true"
ENV IMGPROXY_MAX_SRC_RESOLUTION=25

# Large images might take a bit to download. Increase the timeout to avoid errors.
ENV IMGPROXY_DOWNLOAD_TIMEOUT=15
COPY presets.yml /presets.yml

CMD ["imgproxy", "-presets", "/presets.yml"]


# Expose the port imgproxy will use
EXPOSE 8080
