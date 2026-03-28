import requests
import boto3

PROMETHEUS_URL = "http://SERVER_IP:9090/api/v1/query"
QUERY = 'rate(http_requests_total[1m])'

ec2 = boto3.client('ec2')


def get_requests():

    r = requests.get(PROMETHEUS_URL, params={"query": QUERY})
    data = r.json()

    if data["data"]["result"]:
        return float(data["data"]["result"][0]["value"][1])

    return 0


def stop_servers():

    response = ec2.describe_instances()

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:

            instance_id = instance['InstanceId']

            print("Stopping", instance_id)

            ec2.stop_instances(InstanceIds=[instance_id])


requests_rate = get_requests()

print("Requests per second:", requests_rate)

if requests_rate < 5:
    stop_servers()