import 'package:flutter/material.dart';
import 'calculation_engine.dart';

/// 报告生成Agent
/// 负责生成投决会报告
class ReportAgent {
  
  /// 生成投决会报告摘要
  static String generateReportSummary(FinancialResult result, String projectName) {
    final buffer = StringBuffer();
    
    buffer.writeln('═══ 新能源项目投决会报告摘要 ═══');
    buffer.writeln('');
    buffer.writeln('项目名称: $projectName');
    buffer.writeln('报告时间: ${DateTime.now().toString().substring(0, 16)}');
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────┐');
    buffer.writeln('│         核心财务指标                │');
    buffer.writeln('├─────────────────────────────────────┤');
    buffer.writeln('│ 税前全投资IRR: ${result.irrBeforeTax.toStringAsFixed(2)}%          │');
    buffer.writeln('│ 税后资本金IRR: ${result.irrEquity.toStringAsFixed(2)}%          │');
    buffer.writeln('│ 净现值(NPV): ${result.npv.toStringAsFixed(0)}万元            │');
    buffer.writeln('│ 平准化度电成本: ${result.lcoe.toStringAsFixed(3)}元/kWh       │');
    buffer.writeln('│ 动态投资回收期: ${result.dynamicPayback.toStringAsFixed(1)}年            │');
    buffer.writeln('│ 静态投资回收期: ${result.staticPayback.toStringAsFixed(1)}年            │');
    buffer.writeln('└─────────────────────────────────────┘');
    buffer.writeln('');
    buffer.writeln('投决建议:');
    buffer.writeln(result.getDecisionAdvice());
    buffer.writeln('');
    buffer.writeln('═══ 报告结束 ═══');
    
    return buffer.toString();
  }
  
  /// 导出Excel格式的现金流表
  static String exportCashFlowToCSV(FinancialResult result) {
    final buffer = StringBuffer();
    
    // CSV头
    buffer.writeln('年份,发电量(万kWh),收入(万元),运维(万元),保险(万元),折旧(万元),所得税(万元),净利润(万元),净现金流(万元),累计现金流(万元)');
    
    // 数据行
    for (var y in result.yearlyData) {
      buffer.writeln('${y.year},${y.generation.toStringAsFixed(2)},${y.revenue.toStringAsFixed(2)},${y.omc.toStringAsFixed(2)},${y.insurance.toStringAsFixed(2)},${y.depreciation.toStringAsFixed(2)},${y.tax.toStringAsFixed(2)},${y.netProfit.toStringAsFixed(2)},${y.cashFlow.toStringAsFixed(2)},${y.cumulativeCashFlow.toStringAsFixed(2)}');
    }
    
    return buffer.toString();
  }
}
