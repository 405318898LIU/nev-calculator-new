import 'package:flutter/material.dart';
import 'calculation_engine.dart';
import 'policy_database.dart';
import 'sensitivity_analysis.dart';

/// 敏感性分析Agent
/// 负责多维度敏感性分析与风险评估
class SensitivityAgent {
  
  /// 执行完整敏感性分析
  static SensitivityResult analyze(ProjectParams baseParams) {
    // 基准计算
    final baseResult = CalculationEngine.calculate(params: baseParams);
    
    // 单因素敏感性分析
    final priceSensitivity = _analyzeFactor(
      baseParams, 
      baseResult.irrBeforeTax,
      '上网电价',
      [-20, -15, -10, -5, 0, 5, 10, 15, 20],
      (p, delta) => p.copyWith(
        mechanismPrice: p.mechanismPrice * (1 + delta / 100),
        marketPrice: p.marketPrice * (1 + delta / 100),
      ),
    );
    
    final hoursSensitivity = _analyzeFactor(
      baseParams,
      baseResult.irrBeforeTax,
      '利用小时数',
      [-15, -10, -5, 0, 5, 10, 15],
      (p, delta) => p.copyWith(
        utilizationHours: p.utilizationHours * (1 + delta / 100),
      ),
    );
    
    final investmentSensitivity = _analyzeFactor(
      baseParams,
      baseResult.irrBeforeTax,
      '初始投资',
      [-15, -10, -5, 0, 5, 10, 15],
      (p, delta) => p.copyWith(
        totalInvestment: p.totalInvestment * (1 + delta / 100),
      ),
    );
    
    final omcSensitivity = _analyzeFactor(
      baseParams,
      baseResult.irrBeforeTax,
      '运维成本',
      [-20, -10, 0, 10, 20],
      (p, delta) => p.copyWith(
        omcPerW: p.omcPerW * (1 + delta / 100),
      ),
    );
    
    final loanRateSensitivity = _analyzeFactor(
      baseParams,
      baseResult.irrBeforeTax,
      '贷款利率',
      [-100, -50, 0, 50, 100],
      (p, delta) => p.copyWith(
        loanRate: p.loanRate * (1 + delta / 100),
      ),
    );
    
    // 计算敏感系数 (变化1%引起的IRR变化)
    final sensitivities = [
      _calculateSensitivityCoefficient(priceSensitivity, '上网电价'),
      _calculateSensitivityCoefficient(hoursSensitivity, '利用小时数'),
      _calculateSensitivityCoefficient(investmentSensitivity, '初始投资'),
      _calculateSensitivityCoefficient(omcSensitivity, '运维成本'),
      _calculateSensitivityCoefficient(loanRateSensitivity, '贷款利率'),
    ];
    
    // 按敏感系数排序(龙卷风图顺序)
    sensitivities.sort((a, b) => b.coefficient.abs().compareTo(a.coefficient.abs()));
    
    // 情景分析
    final scenarios = _analyzeScenarios(baseParams);
    
    // 盈亏平衡分析
    final breakEven = _calculateBreakEven(baseParams);
    
    return SensitivityResult(
      baseIRR: baseResult.irrBeforeTax,
      baseNPV: baseResult.npv,
      sensitivities: sensitivities,
      priceAnalysis: priceSensitivity,
      hoursAnalysis: hoursSensitivity,
      investmentAnalysis: investmentSensitivity,
      omcAnalysis: omcSensitivity,
      loanRateAnalysis: loanRateSensitivity,
      scenarios: scenarios,
      breakEven: breakEven,
    );
  }
  
  /// 单因素分析
  static FactorAnalysis _analyzeFactor(
    ProjectParams baseParams,
    double baseIRR,
    String factorName,
    List<int> deltas,
    ProjectParams Function(ProjectParams, int) modifier,
  ) {
    List<DataPoint> points = [];
    
    for (var delta in deltas) {
      final modifiedParams = modifier(baseParams, delta);
      final result = CalculationEngine.calculate(params: modifiedParams);
      
      points.add(DataPoint(
        changePercent: delta,
        irr: result.irrBeforeTax,
        npv: result.npv,
      ));
    }
    
    return FactorAnalysis(
      factorName: factorName,
      baseValue: baseIRR,
      points: points,
    );
  }
  
  /// 计算敏感系数
  static SensitivityItem _calculateSensitivityCoefficient(
    FactorAnalysis analysis,
    String name,
  ) {
    // 取±10%的变化计算平均敏感系数
    final point10 = analysis.points.firstWhere((p) => p.changePercent == 10, orElse: () => analysis.points.last);
    final pointNeg10 = analysis.points.firstWhere((p) => p.changePercent == -10, orElse: () => analysis.points.first);
    
    final irrChange = (point10.irr - pointNeg10.irr) / 2;
    final coefficient = irrChange / 10; // 每变化1%引起的IRR变化
    
    return SensitivityItem(
      name: name,
      coefficient: coefficient,
      irrAtPlus10: point10.irr,
      irrAtMinus10: pointNeg10.irr,
    );
  }
  
  /// 情景分析
  static List<Scenario> _analyzeScenarios(ProjectParams baseParams) {
    return [
      // 乐观情景
      _createScenario('乐观', baseParams, {
        'utilizationHours': 1.05,
        'mechanismPrice': 1.05,
        'totalInvestment': 0.95,
        'omcPerW': 0.95,
      }),
      // 基准情景
      _createScenario('基准', baseParams, {
        'utilizationHours': 1.0,
        'mechanismPrice': 1.0,
        'totalInvestment': 1.0,
        'omcPerW': 1.0,
      }),
      // 悲观情景
      _createScenario('悲观', baseParams, {
        'utilizationHours': 0.95,
        'mechanismPrice': 0.95,
        'totalInvestment': 1.05,
        'omcPerW': 1.05,
      }),
    ];
  }
  
  static Scenario _createScenario(
    String name,
    ProjectParams base,
    Map<String, double> adjustments,
  ) {
    final params = base.copyWith(
      utilizationHours: base.utilizationHours * (adjustments['utilizationHours'] ?? 1.0),
      mechanismPrice: base.mechanismPrice * (adjustments['mechanismPrice'] ?? 1.0),
      totalInvestment: base.totalInvestment * (adjustments['totalInvestment'] ?? 1.0),
      omcPerW: base.omcPerW * (adjustments['omcPerW'] ?? 1.0),
    );
    
    final result = CalculationEngine.calculate(params: params);
    
    return Scenario(
      name: name,
      irr: result.irrBeforeTax,
      npv: result.npv,
      payback: result.dynamicPayback,
      lcoe: result.lcoe,
    );
  }
  
  /// 盈亏平衡分析
  static BreakEvenAnalysis _calculateBreakEven(ProjectParams baseParams) {
    // 电价盈亏平衡点
    final priceBreakEven = _findBreakEven(
      baseParams,
      (p, factor) => p.copyWith(
        mechanismPrice: baseParams.mechanismPrice * factor,
        marketPrice: baseParams.marketPrice * factor,
      ),
    );
    
    // 利用小时盈亏平衡点
    final hoursBreakEven = _findBreakEven(
      baseParams,
      (p, factor) => p.copyWith(
        utilizationHours: baseParams.utilizationHours * factor,
      ),
    );
    
    // 投资盈亏平衡点
    final investmentBreakEven = _findBreakEven(
      baseParams,
      (p, factor) => p.copyWith(
        totalInvestment: baseParams.totalInvestment * factor,
      ),
    );
    
    return BreakEvenAnalysis(
      priceBreakEven: priceBreakEven,
      hoursBreakEven: hoursBreakEven,
      investmentBreakEven: investmentBreakEven,
    );
  }
  
  static double _findBreakEven(
    ProjectParams baseParams,
    ProjectParams Function(ProjectParams, double) modifier,
  ) {
    double low = 0.5;
    double high = 1.5;
    
    for (int i = 0; i < 50; i++) {
      final mid = (low + high) / 2;
      final params = modifier(baseParams, mid);
      final result = CalculationEngine.calculate(params: params);
      
      if (result.irrBeforeTax > 6.5) {
        high = mid;
      } else {
        low = mid;
      }
    }
    
    return (low + high) / 2;
  }
}

/// 敏感性分析结果
class SensitivityResult {
  final double baseIRR;
  final double baseNPV;
  final List<SensitivityItem> sensitivities;
  final FactorAnalysis priceAnalysis;
  final FactorAnalysis hoursAnalysis;
  final FactorAnalysis investmentAnalysis;
  final FactorAnalysis omcAnalysis;
  final FactorAnalysis loanRateAnalysis;
  final List<Scenario> scenarios;
  final BreakEvenAnalysis breakEven;
  
  SensitivityResult({
    required this.baseIRR,
    required this.baseNPV,
    required this.sensitivities,
    required this.priceAnalysis,
    required this.hoursAnalysis,
    required this.investmentAnalysis,
    required this.omcAnalysis,
    required this.loanRateAnalysis,
    required this.scenarios,
    required this.breakEven,
  });
  
  /// 获取最敏感的因素
  String get mostSensitiveFactor => sensitivities.first.name;
  
  /// 获取风险等级
  String get riskLevel {
    final maxCoefficient = sensitivities.first.coefficient.abs();
    if (maxCoefficient > 0.08) return '高风险';
    if (maxCoefficient > 0.05) return '中风险';
    return '低风险';
  }
  
  Color get riskColor {
    final level = riskLevel;
    if (level == '高风险') return Colors.red;
    if (level == '中风险') return Colors.orange;
    return Colors.green;
  }
}

/// 敏感项
class SensitivityItem {
  final String name;
  final double coefficient; // 敏感系数(每变化1%引起的IRR变化)
  final double irrAtPlus10;
  final double irrAtMinus10;
  
  SensitivityItem({
    required this.name,
    required this.coefficient,
    required this.irrAtPlus10,
    required this.irrAtMinus10,
  });
}

/// 因素分析
class FactorAnalysis {
  final String factorName;
  final double baseValue;
  final List<DataPoint> points;
  
  FactorAnalysis({
    required this.factorName,
    required this.baseValue,
    required this.points,
  });
}

/// 数据点
class DataPoint {
  final int changePercent;
  final double irr;
  final double npv;
  
  DataPoint({
    required this.changePercent,
    required this.irr,
    required this.npv,
  });
}

/// 情景
class Scenario {
  final String name;
  final double irr;
  final double npv;
  final double payback;
  final double lcoe;
  
  Scenario({
    required this.name,
    required this.irr,
    required this.npv,
    required this.payback,
    required this.lcoe,
  });
}

/// 盈亏平衡分析
class BreakEvenAnalysis {
  final double priceBreakEven; // 电价盈亏平衡点(相对于基准的比例)
  final double hoursBreakEven; // 利用小时盈亏平衡点
  final double investmentBreakEven; // 投资盈亏平衡点
  
  BreakEvenAnalysis({
    required this.priceBreakEven,
    required this.hoursBreakEven,
    required this.investmentBreakEven,
  });
  
  /// 获取临界值下降空间
  Map<String, String> get criticalMargins => {
    '电价': '${((1 - priceBreakEven) * 100).toStringAsFixed(1)}%',
    '利用小时': '${((1 - hoursBreakEven) * 100).toStringAsFixed(1)}%',
    '初始投资': '${((investmentBreakEven - 1) * 100).toStringAsFixed(1)}%',
  };
}
