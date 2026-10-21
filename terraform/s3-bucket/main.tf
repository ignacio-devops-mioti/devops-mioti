# ---------------------------------------------------------------
# Sesion 4 - Primer despliegue: un bucket S3 con etiquetas
# terraform init -> terraform plan -> terraform apply -> terraform destroy
# ---------------------------------------------------------------

variable "region" {
  description = "Region de AWS donde se crea el bucket"
  type        = string
  default     = "eu-west-1"
}

variable "departamento" {
  description = "Departamento al que se imputa el coste (etiqueta)"
  type        = string
  default     = "formacion"
}

# Los nombres de bucket son unicos en todo el mundo: anadimos un sufijo aleatorio
resource "random_id" "sufijo" {
  byte_length = 4
}

resource "aws_s3_bucket" "demo" {
  bucket        = "devops-mioti-${random_id.sufijo.hex}"
  force_destroy = true # permite destruirlo aunque tenga ficheros

  tags = {
    Name         = "bucket-demo-s4"
    Departamento = var.departamento
    Entorno      = "clase"
  }
}

# Buena practica: bloquear cualquier acceso publico al bucket
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket                  = aws_s3_bucket.demo.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "nombre_bucket" {
  value = aws_s3_bucket.demo.bucket
}

output "arn_bucket" {
  value = aws_s3_bucket.demo.arn
}
