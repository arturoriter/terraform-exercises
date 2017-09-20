resource "aws_lambda_function" "exchange_lambda" {
  filename          = "exchange-currency-1.0-SNAPSHOT.jar"
  function_name     = "exchange_lambda"
  role              = "${aws_iam_role.role_lambda.arn}"
  handler           = "br.riter.exchangecurrency.MonthExchange::handleRequest"
  runtime           = "java8"
  source_code_hash  = "${base64sha256(file("exchange-currency-1.0-SNAPSHOT.jar"))}"
  timeout           = 120
  memory_size       = 512
}
