resource "aws_dynamodb_table" "hitcounter-table" {
  name           = "CRCHitCounter"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Website"
    
  attribute {
    name = "Website"
    type = "S"
  }

}

resource "aws_dynamodb_table_item" "hits" {
  table_name = aws_dynamodb_table.hitcounter-table.name
  hash_key   = aws_dynamodb_table.hitcounter-table.hash_key

  item = <<ITEM
{
  "Website": {"S": "bhaas"},
  "Hits": {"N": "0"}
  }
ITEM
}