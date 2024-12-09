###########
# BUILDER #
###########

FROM python:3.11.4-slim-buster AS builder
WORKDIR /usr/src/app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    pip install --upgrade pip && \
    rm -rf /var/lib/apt/lists/*

COPY . /usr/src/app/
COPY ./requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt

#########
# FINAL #
#########

FROM python:3.11.4-slim-buster
RUN addgroup --system app && adduser --system --group app

ENV HOME=/home/app
ENV APP_HOME=/home/app/web
WORKDIR $APP_HOME

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN pip install --no-cache /wheels/*

COPY . $APP_HOME
RUN chown -R app:app $APP_HOME

USER app

# Use PORT variable, allowing it to be configured externally
ENV PORT=8000
EXPOSE $PORT

CMD ["gunicorn", "--workers=3", "--timeout=120", "--bind", "0.0.0.0:$PORT", "base.wsgi:application"]
