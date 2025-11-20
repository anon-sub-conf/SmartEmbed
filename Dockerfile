FROM python:2.7-slim

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
    && printf "Acquire::Check-Valid-Until \"false\";\n" > /etc/apt/apt.conf.d/99no-check-valid \
    && apt-get update

# create man directory needed by Java postinst
RUN mkdir -p /usr/share/man/man1

RUN apt-get install -y --no-install-recommends \
    python-dev \
    build-essential \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    openjdk-11-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt ./
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt

COPY . .
RUN ./download_models.sh
CMD ["python", "make_embeddings.py"]
