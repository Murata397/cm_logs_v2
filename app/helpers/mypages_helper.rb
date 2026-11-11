module MypagesHelper
  CHART_WIDTH = 600
  CHART_HEIGHT = 220
  CHART_PADDING = 36

  # 燃費の記録を、グラフ上の点の位置（x, y）に変換する
  def fuel_chart(logs)
    values = logs.map { |log| log.efficiency.to_f }
    min = [(values.min - 2).floor, 0].max
    max = (values.max + 2).ceil
    range = (max - min).nonzero? || 1
    inner_w = CHART_WIDTH - CHART_PADDING * 2
    inner_h = CHART_HEIGHT - CHART_PADDING * 2

    points = logs.each_with_index.map do |log, i|
      x = values.size > 1 ? CHART_PADDING + inner_w * i / (values.size - 1).to_f : CHART_WIDTH / 2.0
      y = CHART_PADDING + inner_h * (max - values[i]) / range.to_f
      { x: x.round(1), y: y.round(1), value: values[i], date: log.refueled_on }
    end

    { points: points, min: min, max: max, width: CHART_WIDTH, height: CHART_HEIGHT, padding: CHART_PADDING }
  end
end
