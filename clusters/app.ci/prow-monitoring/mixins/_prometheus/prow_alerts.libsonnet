{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'prow',
        rules: [
          {
            alert: 'prow-pod-crashlooping',
            expr: 'rate(kube_pod_container_status_restarts_total{namespace=~"ci|prow-monitoring",job="kube-state-metrics"}[15m]) * 60 * 5 > 0',
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Pod {{ $labels.namespace }}/{{ $labels.pod }} ({{ $labels.container}}) is restarting {{ printf "%.2f" $value }} times / 5 minutes.'
            },
          },
          {
            # We need this for a grafana variable, because grafana itself can only do extremely simplistic queries there
            record: 'github:identity_names',
            expr: 'count(label_replace(count(github_token_usage{token_hash =~ "openshift.*"}) by (token_hash), "login", "$1", "token_hash", "(.*)") or github_user_info{login=~"openshift-.*"}) by (login)'
          }
        ],
      },
    ],
  },
}
