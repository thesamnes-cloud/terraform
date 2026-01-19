FROM hashicorp/terraform:1.6

# Instalar AWS CLI (v2)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    bash \
    curl \
    jq \
    aws-cli

# Directorio de trabajo
WORKDIR /workspace

# Copiamos todo el repo (mono-repo friendly)
COPY . .

# Terraform usará credenciales del IAM Role automáticamente
ENV AWS_REGION=us-east-2
ENV TF_IN_AUTOMATION=true

# Comando por defecto (se sobreescribe en pipeline)
CMD ["terraform", "--version"]
