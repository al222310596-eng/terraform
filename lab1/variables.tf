variable "aplication_name"{
    description = "Nombre de la aplicación"
    type = string
    default = "integradora"
}

variable "enviroment" {
    description = "Entorno de despliegue (dev, staging, prod)"
    type = string
    default = "dev"
}

variable "length"{
    description = "Length of the random string"
    type = number
    default = 5
}

variable "enable_monitoring"{
    description = "Habilitar o deshabilitar el monitoreo"
    type = bool
    default = true
}

variable "regions"{
    description = "Lista de regiones donde se desplegaera la infraestrutura "
    type = list(string)
    default = [ "us-east-1", "us-west-2" ]
}

variable "eviroment_tags"{
    description = "Etiquetas especificas para cada entorno"
    type = map(string)
    default = {
      dev  = "Development"
      prod = "Production"
    }
}

variable "application_config" {
  description = "Configuración especifica de la aplicación"
  type = object({
    version    = string
    maintainer = string
    dependencies = list(string)
  })
  default = {
    version = "1.0.0"
    maintainer = "John Doe"
    dependencies = [ "dependency1", "dependency2" ]
  }
}

variable "allowed_networks" {
  description = "Lista de redes permitidas para acceder a la aplicación"
  type = set(string)
  default = [ "10.0.0.0/16", "10.1.0.0/16" ]
}