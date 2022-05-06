project_id = "amc-marketplacegcp-nonprod"
name = "js1"
region = "europe-west2"
availability_zones = [
  "europe-west2-a",
  "europe-west2-b",
]

create_network = true
vpc_network = "js-vpc1"
vpc_subnet = "js-subnet1"
bucketname = "jsbucket113"
bitism = "32"
use_pac = false

es_image_project = "amc-marketplacegcp-nonprod"
es_image_name = "js-ed80-win2019-18042022"
escount = 1
vm_machine_type = "e2-standard-4"

pg_db_username = "DBadmin2"
pg_db_password = "DBpostgres_1!"
access_ip = "147.147.123.75"