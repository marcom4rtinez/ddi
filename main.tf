terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}


provider "powerdns" {
  api_key    = "changeme"
  server_url = "http://172.18.0.9:8081"
}


resource "powerdns_zone" "example" {
  name        = "example.com."
  kind        = "Native"
  nameservers = ["ns1.example.com.", "ns2.example.com."]
}

resource "powerdns_record" "root" {
  zone    = "example.com."
  name    = "www.example.com."
  type    = "A"
  ttl     = 300
  records = ["192.168.0.11"]
}
