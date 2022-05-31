project_id = "amc-marketplacegcp-nonprod"
name = "js2"
region = "europe-west2"
availability_zones = [
  "europe-west2-a",
  "europe-west2-b",
]
create_network = true
vpc_network = "js-vpc1"
vpc_subnet = "js-subnet1"
bucketname = "jsbucket2"
bitism = "32"
use_pac = false
es_image_project = "amc-marketplacegcp-nonprod"
es_image_name = "js-rh-ed70pu5-20220523"
escount = 1
vm_machine_type = "e2-standard-4"

access_ip = "0.0.0.0/0"
#access_ip = "172.253.215.0/24" #GCP
