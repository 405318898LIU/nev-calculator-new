import 'package:flutter_test/flutter_test.dart';
import '../lib/calculation_engine.dart';
import '../lib/policy_database.dart';
import '../lib/sensitivity_agent.dart';

void main() {
  group('计算引擎测试', () {
    test('IRR计算测试', () {
      // 测试现金流 [-1000, 300, 400, 400, 300]
      final cashFlows = [-1000.0, 300.0, 400.0, 400.0, 300.0];
      final irr = CalculationEngine.calculateIRR(cashFlows);
      expect(irr, greaterThan(10)); // IRR应该大于10%
      expect(irr, lessThan(11));
    });
    
    test('NPV计算测试', () {
      final cashFlows = [-1000.0, 300.0, 400.0, 400.0, 300.0];
      final npv = CalculationEngine.calculateNPV(cashFlows, 0.10);
      expect(npv, greaterThan(0));
    });
    
    test('动态回收期测试', () {
      final cashFlows = [-1000.0, 200.0, 300.0, 400.0, 500.0];
      final payback = CalculationEngine.calculateDynamicPayback(cashFlows, 0.10);
      expect(payback, greaterThan(3));
      expect(payback, lessThan(4));
    });
    
    test('静态回收期测试', () {
      final cashFlows = [-1000.0, 200.0, 300.0, 400.0, 500.0];
      final payback = CalculationEngine.calculateStaticPayback(cashFlows);
      expect(payback, greaterThan(3));
      expect(payback, lessThan(4));
    });
    
    test('LCOE计算测试', () {
      final annualGen = [1000.0, 1000.0, 1000.0, 1000.0, 1000.0];
      final lcoe = CalculationEngine.calculateLCOE(
        totalInvestment: 3500,
        annualGeneration: annualGen,
        omcCost: 50,
        discountRate: 0.07,
      );
      expect(lcoe, greaterThan(0.3));
      expect(lcoe, lessThan(1.0));
    });
  });
  
  group('政策数据库测试', () {
    test('获取省份列表', () {
      final provinces = ProvincePolicyDatabase.provinceNames;
      expect(provinces.length, greaterThan(30));
      expect(provinces.contains('贵州'), true);
      expect(provinces.contains('广东'), true);
    });
    
    test('获取贵州政策', () {
      final policy = ProvincePolicyDatabase.getPolicy('贵州');
      expect(policy, isNotNull);
      expect(policy!.benchmarkPrice, 0.3515);
    });
    
    test('获取机制电价', () {
      final price = ProvincePolicyDatabase.getMechanismPrice('贵州', isNewProject: false);
      expect(price, 0.3515);
    });
    
    test('获取投决门槛', () {
      expect(InvestmentThreshold.pvGroundIRR, 6.5);
      expect(InvestmentThreshold.windOnshoreIRR, 6.5);
    });
  });
  
  group('完整项目计算测试', () {
    test('贵州100MW光伏项目计算', () {
      final params = ProjectParams(
        totalInvestment: 35000, // 100MW * 3.5元/W
        constructionPeriod: 12,
        operationPeriod: 25,
        capacity: 100,
        utilizationHours: 1100,
        mechanismPrice: 0.3515,
        mechanismRatio: 80,
        mechanismPeriod: 20,
        marketPrice: 0.3515 * 0.85,
        marketRatio: 20,
        greenPrice: 0.02,
        omcPerW: 0.05,
      );
      
      final result = CalculationEngine.calculate(params: params);
      
      // 验证结果合理性
      expect(result.irrBeforeTax, greaterThan(5));
      expect(result.irrBeforeTax, lessThan(15));
      expect(result.npv, isNotNaN);
      expect(result.lcoe, greaterThan(0.2));
      expect(result.lcoe, lessThan(0.5));
      expect(result.dynamicPayback, greaterThan(5));
      expect(result.dynamicPayback, lessThan(15));
    });
    
    test('投决判断测试', () {
      // 创建一个IRR=7%的项目(通过投决)
      final goodParams = ProjectParams(
        totalInvestment: 30000,
        constructionPeriod: 12,
        operationPeriod: 25,
        capacity: 100,
        utilizationHours: 1300, // 较好的资源
        mechanismPrice: 0.35,
        mechanismRatio: 80,
        mechanismPeriod: 20,
        marketPrice: 0.35 * 0.85,
        marketRatio: 20,
        greenPrice: 0.02,
        omcPerW: 0.05,
      );
      
      final goodResult = CalculationEngine.calculate(params: goodParams);
      expect(goodResult.isViable, true);
      expect(goodResult.irrBeforeTax, greaterThanOrEqualTo(6.5));
    });
  });
  
  group('敏感性分析测试', () {
    test('敏感性分析执行', () {
      final params = ProjectParams(
        totalInvestment: 35000,
        constructionPeriod: 12,
        operationPeriod: 25,
        capacity: 100,
        utilizationHours: 1100,
        mechanismPrice: 0.3515,
        mechanismRatio: 80,
        mechanismPeriod: 20,
        marketPrice: 0.3515 * 0.85,
        marketRatio: 20,
        greenPrice: 0.02,
        omcPerW: 0.05,
      );
      
      final sensitivity = SensitivityAgent.analyze(params);
      
      expect(sensitivity.sensitivities.length, greaterThan(0));
      expect(sensitivity.scenarios.length, 3); // 乐观、基准、悲观
      expect(sensitivity.breakEven.priceBreakEven, greaterThan(0));
      expect(sensitivity.breakEven.priceBreakEven, lessThan(1.5));
    });
  });
  
  print('所有测试通过!');
}
