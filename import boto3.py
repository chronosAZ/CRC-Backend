import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('YourTableName')

    try:
        response = table.get_item(
            Key={
                'YourPrimaryKey': 'YourPrimaryKeyValue'
            }
        )
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': 'Error in getting item'
        }

    return {
        'statusCode': 200,
        'body': response
    }