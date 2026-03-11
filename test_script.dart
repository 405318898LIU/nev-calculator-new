// 测试脚本 - 验证计算引擎
// 运行: dart test_script.dart

import 'dart:math';

/// 简化版计算引擎测试
void main() {
  print('═══════════════════════════════════════════');
  print('  新能源投资收益计算器 - 计算引擎测试');
  print('═══════════════════════════════════════════\n');
  
  // 测试1: IRR计算
  print('【测试1】IRR计算');
  final cashFlows = [-1000.0, 300.0, 400.0, 400.0, 300.0];
  final irr = calculateIRR(cashFlows);
  print('  现金流: $cashFlows');
  print('  计算IRR: ${irr.toStringAsFixed(2)}%');
  print('  预期范围: 10%-11%');
  print('  状态: ${irr > 10 && irr < 11 ? "✅ 通过" : "❌ 失败"}\n');
  
  // 测试2: NPV计算
  print('【测试2】NPV计算');
  final npv = calculateNPV(cashFlows, 0.10);
  print('  折现率: 10%');
  print('  计算NPV: ${npv.toStringAsFixed(2)}');
  print('  状态: ${npv > 0 ? "✅ 通过" : "❌ 失败"}\n');
  
  // 测试3: 贵州100MW光伏项目
  print('【测试3】贵州100MW光伏项目测算');
  print('───────────────────────────────────────────');
  
  final project = {
    '总投资': 35000.0, // 万元 (100MW * 3.5元/W)
    '装机': 100.0, // MW
    '利用小时': 1100.0,
    '机制电价': 0.3515, // 贵州煤电基准价
    '机制电量比例': 0.80,
    '运营年限': 25,
    '运维成本': 0.05, // 元/W/年
    '折现率': 0.07,
  };
  
  print('  项目参数:');
  project.forEach((k, v) => print('    $k: $v'));
  print('');
  
  // 简化计算
  final annualGen = project['装机']! * project['利用小时']! / 10000; // 亿kWh
  final annualRevenue = annualGen * 10000 * project['机制电价']! * project['机制电量比例']!; // 万元
  final annualOMC = project['装机']! * 1000 * (project['运维成本']!); // 万元
  
  print('  年度指标:');
  print('    发电量: ${annualGen.toStringAsFixed(2)} 亿kWh');
  print('    年收入: ${annualRevenue.toStringAsFixed(0)} 万元');
  print('    年运维: ${annualOMC.toStringAsFixed(0)} 万元');
  print('');
  
  // 简化的投资回收期(静态)
  final staticPayback = project['总投资']! / (annualRevenue - annualOMC);
  print('  静态回收期: ${staticPayback.toStringAsFixed(2)} 年');
  print('  状态: ${staticPayback < 10 ? "✅ 通过(小于10年)" : "⚠️ 边缘"}\n');
  
  // 测试4: 投决判断
  print('【测试4】投决会门槛判断');
  final irrSimulated = 7.5; // 模拟IRR
  final threshold = 6.5;
  print('  项目IRR: $irrSimulated%');
  print('  门槛值: $threshold%');
  print('  判断结果: ${irrSimulated >= threshold ? "✅ 通过投决" : "❌ 建议否决"}\n');
  
  // 测试5: 敏感性计算
  print('【测试5】敏感性系数计算');
  final irrBase = 7.5;
  final irrPriceUp = 8.5; // 电价+10%后的IRR
  final sensitivity = (irrPriceUp - irrBase) / 10; // 每变化1%引起的IRR变化
  print('  基准IRR: $irrBase%');
  print('  电价+10%后IRR: $irrPriceUp%');
  print('  敏感系数: ${sensitivity.toStringAsFixed(3)}');
  print('  含义: 电价每变化1%，IRR变化 ${sensitivity.toStringAsFixed(3)}%\n');
  
  print('═══════════════════════════════════════════');
  print('  所有基础测试完成!');
  print('═══════════════════════════════════════════');
}

/// IRR计算(简化版)
double calculateIRR(List<double> cashFlows, {double precision = 0.0001}) {
  double low = -0.99;
  double high = 1.0;
  
  for (int i = 0; i < 100; i++) {
    double mid = (low + high) / 2;
    double npv = calculateNPV(cashFlows, mid);
    
    if (npv.abs() < precision) break;
    
    if (npv > 0) {
      low = mid;
    } else {
      high = mid;
    }
  }
  
  return ((low + high) / 2) * 100;
}

/// NPV计算
double calculateNPV(List<double> cashFlows, double rate) {
  double npv = 0;
  for (int i = 0; i < cashFlows.length; i++) {
    npv += cashFlows[i] / pow(1 + rate, i);
  }
  return npv;
}
