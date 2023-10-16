resource "aws_cloudwatch_event_rule" "console" {
  name        = "capture-ec2-scaling-events"
  description = "Capture all EC2 scaling events"

  event_pattern = jsonencode({
    source = [
      "aws.autoscaling"
    ]

    detail-type = [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful",
      "EC2 Instance Launch Unsuccessful",
      "EC2 Instance Terminate Unsuccessful"
    ]

    detail = {
      "AutoScalingGroupName" : [
        "${aws_autoscaling_group.project.name}"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "console" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "sendToEmail"
  arn       = aws_sns_topic.monitoring_notification_topic.arn
}

resource "aws_sns_topic" "monitoring_notification_topic" {
  name              = "MonitoringNotificationTopic"
  kms_master_key_id = "aws/sns"
}

resource "aws_sns_topic_subscription" "monitoring_notification_topic" {
  topic_arn = aws_sns_topic.monitoring_notification_topic.arn
  protocol  = "email"
  endpoint  = "svetoslav.ekov01@gmail.com"
}

resource "aws_sns_topic_policy" "monitoring_notification_topic" {
  arn    = aws_sns_topic.monitoring_notification_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "sns-topic-policy"

  statement {
    sid     = "PublishEventsToMyTopic"
    actions = ["SNS:Publish"]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.monitoring_notification_topic.arn,
    ]
  }
}