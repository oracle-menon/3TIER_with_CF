resource "aws_sns_topic" "budget_notification_topic" {
  name              = "BudgetNotificationTopic"
  kms_master_key_id = "aws/sns"
}
resource "aws_sns_topic_subscription" "budget_notification_topic" {
  topic_arn = aws_sns_topic.budget_notification_topic.arn
  protocol  = "email"
  endpoint  = "svetoslav.ekov01@gmail.com"
}
resource "aws_budgets_budget" "budget_notification_topic" {
  name              = "MonthlyBudget"
  budget_type       = "COST"
  limit_amount      = var.budget_cost
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2023-09-12_00:00"
  time_period_end   = "2087-01-01_00:00"
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 1.0
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["svetoslav.ekov01@gmail.com"]
  }
  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = var.budget_cost
    threshold_type            = "ABSOLUTE_VALUE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_notification_topic.arn]
  }
}

