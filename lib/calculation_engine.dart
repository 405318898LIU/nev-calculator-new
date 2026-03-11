import 'dart:math';
import 'package:flutter/foundation.dart';

/// 新能源项目财务计算核心引擎
/// 负责IRR、NPV、LCOE、投资回收期等核心指标计算
class CalculationEngine {
  
  /// 计算税前全投资IRR
  /// [cashFlows]: 各年净现金流(首年为负的投资)
  /// 返回: IRR百分比值
  static double calculateIRR(List<double> cashFlows, {double precision = 0.0001}) {
    if (cashFlows.isEmpty || cashFlows[0] >= 0) return 0.0;
    
    double low = -0.99;
    double high = 1.0;
    double mid = 0.1;
    
    // 使用二分法+牛顿迭代计算IRR
    for (int i = 0; i < 100; i++) {
      mid = (low + high) / 2;
      double npv = _calculateNPV(cashFlows, mid);
      
      if (npv.abs() < precision) break;
      
      if (npv > 0) {
        low = mid;
      } else {
        high = mid;
      }
    }
    
    return mid * 100; // 转换为百分比
  }
  
  /// 计算NPV
  /// [cashFlows]: 各年现金流
  /// [discountRate]: 折现率(如0.07表示7%)
  static double calculateNPV(List<double> cashFlows, double discountRate) {
    return _calculateNPV(cashFlows, discountRate);
  }
  
  static double _calculateNPV(List<double> cashFlows, double rate) {
    double npv = 0;
    for (int i = 0; i < cashFlows.length; i++) {
      npv += cashFlows[i] / pow(1 + rate, i);
    }
    return npv;
  }
  
  /// 计算税后资本金IRR
  /// 考虑融资结构和税收影响
  static double calculateEquityIRR({
    required double totalInvestment, // 总投资(万元)
    required double equityRatio, // 资本金比例
    required double loanRate, // 贷款利率
    required int loanTerm, // 贷款期限
    required List<double> annualNetCashFlow, // 各年净现金流
  }) {
    double equity = totalInvestment * equityRatio;
    double loan = totalInvestment * (1 - equityRatio);
    
    // 计算等额本息还款
    double monthlyRate = loanRate / 12 / 100;
    int months = loanTerm * 12;
    double monthlyPayment = loan * monthlyRate * pow(1 + monthlyRate, months) / 
                           (pow(1 + monthlyRate, months) - 1);
    double annualPayment = monthlyPayment * 12;
    
    // 构建资本金现金流
    List<double> equityCashFlows = [-equity];
    
    for (int year = 1; year <= annualNetCashFlow.length; year++) {
      double principalRepayment = 0;
      double interestPayment = 0;
      
      if (year <= loanTerm) {
        // 简化计算：年均还款
        principalRepayment = loan / loanTerm;
        interestPayment = annualPayment - principalRepayment;
      }
      
      // 资本金现金流 = 项目现金流 - 还本付息
      double equityCashFlow = annualNetCashFlow[year - 1] - annualPayment;
      
      // 最后一年加上残值(简化按5%计算)
      if (year == annualNetCashFlow.length) {
        equityCashFlow += totalInvestment * 0.05;
      }
      
      equityCashFlows.add(equityCashFlow);
    }
    
    return calculateIRR(equityCashFlows);
  }
  
  /// 计算平准化度电成本(LCOE)
  /// 单位: 元/kWh
  static double calculateLCOE({
    required double totalInvestment, // 总投资(万元)
    required List<double> annualGeneration, // 各年发电量(万kWh)
    required double omcCost, // 年均运维成本(万元)
    required double discountRate, // 折现率
  }) {
    // 投资现值
    double investmentPV = totalInvestment;
    
    // 运维成本现值
    double omcPV = 0;
    for (int i = 0; i < annualGeneration.length; i++) {
      omcPV += omcCost / pow(1 + discountRate, i + 1);
    }
    
    // 发电量现值
    double generationPV = 0;
    for (int i = 0; i < annualGeneration.length; i++) {
      generationPV += annualGeneration[i] / pow(1 + discountRate, i + 1);
    }
    
    return (investmentPV + omcPV) / generationPV;
  }
  
  /// 计算动态投资回收期
  static double calculateDynamicPayback(List<double> cashFlows, double discountRate) {
    double cumulative = 0;
    int paybackYear = 0;
    
    for (int i = 0; i < cashFlows.length; i++) {
      double discountedCF = cashFlows[i] / pow(1 + discountRate, i);
      cumulative += discountedCF;
      
      if (cumulative >= 0 && paybackYear == 0) {
        // 使用线性插值计算精确回收期
        double prevCumulative = cumulative - discountedCF;
        double fraction = prevCumulative.abs() / discountedCF;
        paybackYear = i;
        return i - 1 + fraction;
      }
    }
    
    return paybackYear > 0 ? paybackYear.toDouble() : double.infinity;
  }
  
  /// 计算静态投资回收期
  static double calculateStaticPayback(List<double> cashFlows) {
    double cumulative = 0;
    
    for (int i = 0; i < cashFlows.length; i++) {
      cumulative += cashFlows[i];
      
      if (cumulative >= 0) {
        double prevCumulative = cumulative - cashFlows[i];
        double fraction = prevCumulative.abs() / cashFlows[i];
        return i - 1 + fraction;
      }
    }
    
    return double.infinity;
  }
  
  /// 生成项目完整现金流
  static ProjectCashFlow generateCashFlow({
    required double totalInvestment,
    required int constructionPeriod, // 建设期(月)
    required int operationPeriod, // 运营期(年)
    required double capacity, // 装机(MW)
    required double utilizationHours, // 年利用小时
    required double degradationRate, // 首年衰减率
    required double annualDegradation, // 年衰减率
    required double mechanismPrice, // 机制电价(元/kWh)
    required double mechanismRatio, // 机制电量比例
    required int mechanismPeriod, // 机制执行期(年)
    required double marketPrice, // 市场化电价(元/kWh)
    required double marketRatio, // 市场化比例
    required double greenPrice, // 绿证收益(元/kWh)
    required double omcPerW, // 运维成本(元/W/年)
    required double insuranceRate, // 保险费率(%)
    required double taxRate, // 所得税率(%)
    required double depreciationYears, // 折旧年限
  }) {
    List<double> cashFlows = [];
    List<double> annualGeneration = [];
    List<YearlyData> yearlyData = [];
    
    // 建设期现金流(负值)
    double monthlyInvestment = totalInvestment / constructionPeriod;
    for (int i = 0; i < constructionPeriod; i++) {
      cashFlows.add(-monthlyInvestment);
    }
    
    // 运营期现金流
    double depreciation = totalInvestment / depreciationYears;
    double totalCapacity = capacity * 10000; // 转换为kW
    double annualOMC = totalCapacity * omcPerW / 10000; // 万元
    double annualInsurance = totalInvestment * insuranceRate / 100;
    
    double cumulativeCashFlow = -totalInvestment;
    
    for (int year = 1; year <= operationPeriod; year++) {
      // 计算发电量(考虑衰减)
      double degradationFactor = 1.0;
      if (year == 1) {
        degradationFactor = 1 - degradationRate / 100;
      } else {
        degradationFactor = (1 - degradationRate / 100) * 
                           pow(1 - annualDegradation / 100, year - 1);
      }
      
      double generation = capacity * utilizationHours * degradationFactor; // 万kWh
      annualGeneration.add(generation);
      
      // 计算收入
      double effectiveMechanismRatio = year <= mechanismPeriod ? mechanismRatio : 0;
      double mechanismRevenue = generation * effectiveMechanismRatio / 100 * mechanismPrice;
      double marketRevenue = generation * marketRatio / 100 * marketPrice;
      double greenRevenue = generation * greenPrice;
      double totalRevenue = mechanismRevenue + marketRevenue + greenRevenue;
      
      // 计算成本
      double totalCost = annualOMC + annualInsurance;
      
      // 计算利润和税收
      double taxableIncome = totalRevenue - totalCost - depreciation;
      double tax = taxableIncome > 0 ? taxableIncome * taxRate / 100 : 0;
      double netProfit = taxableIncome - tax;
      
      // 净现金流 = 净利润 + 折旧
      double cashFlow = netProfit + depreciation;
      
      cumulativeCashFlow += cashFlow;
      
      cashFlows.add(cashFlow);
      
      yearlyData.add(YearlyData(
        year: year,
        generation: generation,
        revenue: totalRevenue,
        omc: annualOMC,
        insurance: annualInsurance,
        depreciation: depreciation,
        tax: tax,
        netProfit: netProfit,
        cashFlow: cashFlow,
        cumulativeCashFlow: cumulativeCashFlow,
      ));
    }
    
    return ProjectCashFlow(
      cashFlows: cashFlows,
      annualGeneration: annualGeneration,
      yearlyData: yearlyData,
    );
  }
  
  /// 执行完整财务计算
  static FinancialResult calculate({
    required ProjectParams params,
  }) {
    // 生成现金流
    var cashFlow = generateCashFlow(
      totalInvestment: params.totalInvestment,
      constructionPeriod: params.constructionPeriod,
      operationPeriod: params.operationPeriod,
      capacity: params.capacity,
      utilizationHours: params.utilizationHours,
      degradationRate: params.degradationRate,
      annualDegradation: params.annualDegradation,
      mechanismPrice: params.mechanismPrice,
      mechanismRatio: params.mechanismRatio,
      mechanismPeriod: params.mechanismPeriod,
      marketPrice: params.marketPrice,
      marketRatio: params.marketRatio,
      greenPrice: params.greenPrice,
      omcPerW: params.omcPerW,
      insuranceRate: params.insuranceRate,
      taxRate: params.taxRate,
      depreciationYears: params.depreciationYears,
    );
    
    // 转换为年度现金流(简化：合并建设期)
    List<double> annualCashFlows = [-params.totalInvestment];
    annualCashFlows.addAll(cashFlow.yearlyData.map((y) => y.cashFlow));
    
    // 计算各项指标
    double irr = calculateIRR(annualCashFlows);
    double npv = calculateNPV(annualCashFlows, params.discountRate / 100);
    double lcoe = calculateLCOE(
      totalInvestment: params.totalInvestment,
      annualGeneration: cashFlow.annualGeneration,
      omcCost: params.capacity * 10000 * params.omcPerW / 10000,
      discountRate: params.discountRate / 100,
    );
    double dynamicPayback = calculateDynamicPayback(annualCashFlows, params.discountRate / 100);
    double staticPayback = calculateStaticPayback(annualCashFlows);
    
    // 计算资本金IRR
    double equityIRR = calculateEquityIRR(
      totalInvestment: params.totalInvestment,
      equityRatio: params.equityRatio / 100,
      loanRate: params.loanRate,
      loanTerm: params.loanTerm,
      annualNetCashFlow: cashFlow.yearlyData.map((y) => y.cashFlow).toList(),
    );
    
    return FinancialResult(
      irrBeforeTax: irr,
      irrEquity: equityIRR,
      npv: npv,
      lcoe: lcoe,
      dynamicPayback: dynamicPayback,
      staticPayback: staticPayback,
      yearlyData: cashFlow.yearlyData,
      maxFundingGap: cashFlow.yearlyData.map((y) => y.cumulativeCashFlow).reduce((a, b) => a < b ? a : b),
    );
  }
}

/// 项目参数
class ProjectParams {
  double totalInvestment; // 总投资(万元)
  int constructionPeriod; // 建设期(月)
  int operationPeriod; // 运营期(年)
  double capacity; // 装机(MW)
  double utilizationHours; // 年利用小时
  double degradationRate; // 首年衰减率(%)
  double annualDegradation; // 年衰减率(%)
  double mechanismPrice; // 机制电价(元/kWh)
  double mechanismRatio; // 机制电量比例(%)
  int mechanismPeriod; // 机制执行期(年)
  double marketPrice; // 市场化电价(元/kWh)
  double marketRatio; // 市场化比例(%)
  double greenPrice; // 绿证收益(元/kWh)
  double omcPerW; // 运维成本(元/W/年)
  double insuranceRate; // 保险费率(%)
  double taxRate; // 所得税率(%)
  double depreciationYears; // 折旧年限
  double discountRate; // 折现率(%)
  double equityRatio; // 资本金比例(%)
  double loanRate; // 贷款利率(%)
  int loanTerm; // 贷款期限(年)
  
  ProjectParams({
    required this.totalInvestment,
    required this.constructionPeriod,
    required this.operationPeriod,
    required this.capacity,
    required this.utilizationHours,
    this.degradationRate = 2.0,
    this.annualDegradation = 0.5,
    required this.mechanismPrice,
    required this.mechanismRatio,
    required this.mechanismPeriod,
    required this.marketPrice,
    required this.marketRatio,
    this.greenPrice = 0.02,
    this.omcPerW = 0.05,
    this.insuranceRate = 0.1,
    this.taxRate = 25,
    this.depreciationYears = 20,
    this.discountRate = 7,
    this.equityRatio = 20,
    this.loanRate = 3.5,
    this.loanTerm = 15,
  });
}

/// 项目现金流
class ProjectCashFlow {
  final List<double> cashFlows;
  final List<double> annualGeneration;
  final List<YearlyData> yearlyData;
  
  ProjectCashFlow({
    required this.cashFlows,
    required this.annualGeneration,
    required this.yearlyData,
  });
}

/// 年度数据
class YearlyData {
  final int year;
  final double generation;
  final double revenue;
  final double omc;
  final double insurance;
  final double depreciation;
  final double tax;
  final double netProfit;
  final double cashFlow;
  final double cumulativeCashFlow;
  
  YearlyData({
    required this.year,
    required this.generation,
    required this.revenue,
    required this.omc,
    required this.insurance,
    required this.depreciation,
    required this.tax,
    required this.netProfit,
    required this.cashFlow,
    required this.cumulativeCashFlow,
  });
}

/// 财务计算结果
class FinancialResult {
  final double irrBeforeTax; // 税前全投资IRR(%)
  final double irrEquity; // 税后资本金IRR(%)
  final double npv; // 净现值(万元)
  final double lcoe; // 平准化度电成本(元/kWh)
  final double dynamicPayback; // 动态投资回收期(年)
  final double staticPayback; // 静态投资回收期(年)
  final double maxFundingGap; // 最大资金缺口(万元)
  final List<YearlyData> yearlyData; // 年度明细
  
  FinancialResult({
    required this.irrBeforeTax,
    required this.irrEquity,
    required this.npv,
    required this.lcoe,
    required this.dynamicPayback,
    required this.staticPayback,
    required this.maxFundingGap,
    required this.yearlyData,
  });
  
  /// 判断是否通过投决会
  bool get isViable {
    return irrBeforeTax >= 6.5 && npv > 0;
  }
  
  /// 获取决策建议
  String getDecisionAdvice() {
    if (irrBeforeTax >= 7.0 && npv > 0) {
      return "✅ 强烈推荐：项目IRR超过门槛值${(irrBeforeTax - 6.5).toStringAsFixed(2)}%，具备良好投资价值";
    } else if (irrBeforeTax >= 6.5 && npv > 0) {
      return "✅ 通过投决：项目满足最低收益要求，建议投资";
    } else if (irrBeforeTax >= 6.0 && npv > 0) {
      return "⚠️ 边缘项目：IRR接近门槛值，建议进一步优化成本或争取更好电价";
    } else {
      return "❌ 建议否决：项目IRR未达门槛，投资风险较大";
    }
  }
}
