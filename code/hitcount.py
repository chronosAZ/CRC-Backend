import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('CRCHitCounter')

    try:
        response = table.update_item(
            Key={
                'Website': 'bhaas'
            },
            UpdateExpression='SET Hits = Hits + :val',
            ExpressionAttributeValues={
                ':val': 1
            },
            ReturnValues="UPDATED_NEW"
        )
        hitcount = response['Attributes']['Hits']
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': 'Error in getting item'
        }

    return {
        'statusCode': 200,
        'body': response,
        'hitcount': hitcount
    }