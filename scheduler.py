import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    action = event.get('action')

    filters = [{
        'Name': 'tag:AutoScheduler',
        'Values': ['true']
    }]

    instances = ec2.describe_instances(Filters=filters)
    instance_ids = []

    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])

    if not instance_ids:
        return "No Instance found with the required tag."
    

    if action == 'start':
        ec2.start_instances(InstanceIds=instance_ids)
        return f"Started: {instance_ids}"
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=instance_ids)
        return f"Stopped: {instance_ids}"
    
    return "No action specified."