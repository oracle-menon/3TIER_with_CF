resource "aws_cloudwatch_metric_alarm" "ec2_cpu_project" {
  alarm_name                = "cpu-utilzation-above-80%"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 60
  alarm_description         = "ec2 cpu above 60% utilization"
  alarm_actions             = [aws_sns_topic.budget_notification_topic.arn]
  insufficient_data_actions = []
}
resource "aws_cloudwatch_metric_alarm" "budget_alarm" {
  alarm_name          = "BudgetAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BudgetedCost"
  namespace           = "AWS/Budgets"
  period              = 3600 # 1 hour
  statistic           = "Maximum"
  threshold           = 30.0
  alarm_description   = "Budget exceeded $30"
  alarm_actions       = [aws_sns_topic.budget_notification_topic.arn]
  dimensions = {
    Service = "AWS"
  }
}
# resource "aws_cloudwatch_event_target" "console" {
#   rule      = aws_cloudwatch_event_rule.console.name
#   target_id = "sendToEmail"
#   arn       = aws_sns_topic.monitoring_notification_topic.arn
# }
# resource "aws_sns_topic" "monitoring_notification_topic" {
#   name              = "MonitoringNotificationTopic"
#   kms_master_key_id = "aws/sns"
# }
# resource "aws_sns_topic_subscription" "monitoring_notification_topic" {
#   topic_arn = aws_sns_topic.monitoring_notification_topic.arn
#   protocol  = "email"
#   endpoint  = "svetoslav.ekov01@gmail.com"
# }
# resource "aws_sns_topic_policy" "monitoring_notification_topic" {
#   arn    = aws_sns_topic.monitoring_notification_topic.arn
#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }
# data "aws_iam_policy_document" "sns_topic_policy" {
#   policy_id = "sns-topic-policy"
#   statement {
#     sid     = "PublishEventsToMyTopic"
#     actions = ["SNS:Publish"]
#     effect  = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#     resources = [
#       aws_sns_topic.monitoring_notification_topic.arn,
#     ]
#   }
# }

