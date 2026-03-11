import 'package:flutter/material.dart';
import 'calculation_engine.dart';
import 'policy_database.dart';
import 'sensitivity_agent.dart';

/// 主界面 - 新能源投资收益计算器
class InvestmentCalculatorApp extends StatelessWidget {
  const InvestmentCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新能源投资收益计算器',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> 
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  
  // 表单控制器
  final _projectNameController = TextEditingController(text: '贵州100MW光伏项目');
  final _capacityController = TextEditingController(text: '100');
  final _hoursController = TextEditingController(text: '1100');
  final _unitCostController = TextEditingController(text: '3.5');
  final _mechanismPriceController = TextEditingController(text: '0.3515');
  final _mechanismRatioController = TextEditingController(text: '80');
  final _marketDiscountController = TextEditingController(text: '0.85');
  final _marketRatioController = TextEditingController(text: '20');
  final _greenPriceController = TextEditingController(text: '0.02');
  final _omcController = TextEditingController(text: '0.05');
  final _equityRatioController = TextEditingController(text: '20');
  final _loanRateController = TextEditingController(text: '3.5');
  final _discountRateController = TextEditingController(text: '7');
  
  String _selectedProvince = '贵州';
  String _selectedType = '集中式光伏';
  bool _isNewProject = false;
  int _operationPeriod = 25;
  
  FinancialResult? _result;
  SensitivityResult? _sensitivityResult;
  
  final List<String> _provinces = ProvincePolicyDatabase.provinceNames;
  final List<String> _projectTypes = ['集中式光伏', '分布式光伏', '陆上风电', '海上风电', '储能电站'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _projectNameController.dispose();
    _capacityController.dispose();
    _hoursController.dispose();
    _unitCostController.dispose();
    _mechanismPriceController.dispose();
    _mechanismRatioController.dispose();
    _marketDiscountController.dispose();
    _marketRatioController.dispose();
    _greenPriceController.dispose();
    _omcController.dispose();
    _equityRatioController.dispose();
    _loanRateController.dispose();
    _discountRateController.dispose();
    super.dispose();
  }

  void _updateProvincePolicy() {
    final policy = ProvincePolicyDatabase.getPolicy(_selectedProvince);
    if (policy != null) {
      setState(() {
        if (_isNewProject) {
          // 增量项目按竞价形成
          _mechanismPriceController.text = (policy.benchmarkPrice * 0.85).toStringAsFixed(4);
        } else {
          _mechanismPriceController.text = policy.existingProjectPrice?.toStringAsFixed(4) ?? 
                                          policy.benchmarkPrice.toStringAsFixed(4);
        }
      });
    }
  }

  void _calculate() {
    final capacity = double.tryParse(_capacityController.text) ?? 100;
    final unitCost = double.tryParse(_unitCostController.text) ?? 3.5;
    final totalInvestment = capacity * 1000 * unitCost; // 万元
    
    final params = ProjectParams(
      totalInvestment: totalInvestment,
      constructionPeriod: 12,
      operationPeriod: _operationPeriod,
      capacity: capacity,
      utilizationHours: double.tryParse(_hoursController.text) ?? 1100,
      mechanismPrice: double.tryParse(_mechanismPriceController.text) ?? 0.3515,
      mechanismRatio: double.tryParse(_mechanismRatioController.text) ?? 80,
      mechanismPeriod: 20,
      marketPrice: (double.tryParse(_mechanismPriceController.text) ?? 0.3515) * 
                   (double.tryParse(_marketDiscountController.text) ?? 0.85),
      marketRatio: double.tryParse(_marketRatioController.text) ?? 20,
      greenPrice: double.tryParse(_greenPriceController.text) ?? 0.02,
      omcPerW: double.tryParse(_omcController.text) ?? 0.05,
      discountRate: double.tryParse(_discountRateController.text) ?? 7,
      equityRatio: double.tryParse(_equityRatioController.text) ?? 20,
      loanRate: double.tryParse(_loanRateController.text) ?? 3.5,
    );
    
    final result = CalculationEngine.calculate(params: params);
    final sensitivity = SensitivityAgent.analyze(params);
    
    setState(() {
      _result = result;
      _sensitivityResult = sensitivity;
    });
    
    // 自动切换到结果页
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ 新能源投资收益计算器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: '参数输入'),
            Tab(icon: Icon(Icons.analytics), text: '财务指标'),
            Tab(icon: Icon(Icons.trending_up), text: '敏感性分析'),
            Tab(icon: Icon(Icons.table_chart), text: '现金流明细'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInputTab(),
          _buildResultsTab(),
          _buildSensitivityTab(),
          _buildCashFlowTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _calculate,
        icon: const Icon(Icons.calculate),
        label: const Text('计算收益'),
      ),
    );
  }

  Widget _buildInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('1. 项目基本信息'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _projectNameController,
                    decoration: const InputDecoration(
                      labelText: '项目名称',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedProvince,
                          decoration: const InputDecoration(
                            labelText: '省份',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          items: _provinces.map((p) => 
                            DropdownMenuItem(value: p, child: Text(p))
                          ).toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedProvince = v!;
                              _updateProvincePolicy();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: '项目类型',
                            prefixIcon: Icon(Icons.solar_power),
                          ),
                          items: _projectTypes.map((t) => 
                            DropdownMenuItem(value: t, child: Text(t))
                          ).toList(),
                          onChanged: (v) {
                            setState(() {
                              _selectedType = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: false, label: Text('存量项目')),
                            ButtonSegment(value: true, label: Text('增量项目')),
                          ],
                          selected: {_isNewProject},
                          onSelectionChanged: (s) {
                            setState(() {
                              _isNewProject = s.first;
                              _updateProvincePolicy();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('2. 装机与资源'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _capacityController,
                          decoration: const InputDecoration(
                            labelText: '装机规模',
                            suffixText: 'MW',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          decoration: const InputDecoration(
                            labelText: '年利用小时',
                            suffixText: 'h',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _unitCostController,
                          decoration: const InputDecoration(
                            labelText: '单位投资',
                            suffixText: '元/W',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _operationPeriod,
                          decoration: const InputDecoration(
                            labelText: '运营年限',
                            suffixText: '年',
                          ),
                          items: [20, 25, 30].map((y) => 
                            DropdownMenuItem(value: y, child: Text('$y年'))
                          ).toList(),
                          onChanged: (v) {
                            setState(() {
                              _operationPeriod = v!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('3. 电价参数'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _mechanismPriceController,
                          decoration: const InputDecoration(
                            labelText: '机制电价',
                            suffixText: '元/kWh',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _mechanismRatioController,
                          decoration: const InputDecoration(
                            labelText: '机制电量比例',
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _marketRatioController,
                          decoration: const InputDecoration(
                            labelText: '市场化比例',
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _marketDiscountController,
                          decoration: const InputDecoration(
                            labelText: '市场化折价系数',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _greenPriceController,
                    decoration: const InputDecoration(
                      labelText: '绿证收益',
                      suffixText: '元/kWh',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          _buildSectionTitle('4. 成本与融资'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _omcController,
                          decoration: const InputDecoration(
                            labelText: '运维成本',
                            suffixText: '元/W/年',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _equityRatioController,
                          decoration: const InputDecoration(
                            labelText: '资本金比例',
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _loanRateController,
                          decoration: const InputDecoration(
                            labelText: '贷款利率',
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _discountRateController,
                          decoration: const InputDecoration(
                            labelText: '折现率',
                            suffixText: '%',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 100), // 为浮动按钮留出空间
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    if (_result == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calculate, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('请点击"计算收益"按钮查看结果', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    
    final r = _result!;
    final threshold = InvestmentThreshold.pvGroundIRR;
    final isPass = r.irrBeforeTax >= threshold;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 决策建议卡片
          Card(
            color: isPass ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    isPass ? Icons.check_circle : Icons.cancel,
                    color: isPass ? Colors.green : Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.getDecisionAdvice(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPass ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 核心指标卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '核心财务指标',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildMetricRow('税前全投资IRR', '${r.irrBeforeTax.toStringAsFixed(2)}%', 
                    benchmark: '>= ${threshold}%', 
                    isPass: r.irrBeforeTax >= threshold),
                  _buildMetricRow('税后资本金IRR', '${r.irrEquity.toStringAsFixed(2)}%', 
                    benchmark: '>= 8%'),
                  _buildMetricRow('净现值(NPV)', '${r.npv.toStringAsFixed(0)}万元', 
                    benchmark: '> 0', 
                    isPass: r.npv > 0),
                  _buildMetricRow('平准化度电成本(LCOE)', '${r.lcoe.toStringAsFixed(3)}元/kWh'),
                  _buildMetricRow('动态投资回收期', '${r.dynamicPayback.toStringAsFixed(1)}年', 
                    benchmark: '<= 10年'),
                  _buildMetricRow('静态投资回收期', '${r.staticPayback.toStringAsFixed(1)}年'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 风险提示
          if (_sensitivityResult != null)
            Card(
              color: _sensitivityResult!.riskColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: _sensitivityResult!.riskColor),
                        const SizedBox(width: 8),
                        Text(
                          '风险等级: ${_sensitivityResult!.riskLevel}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _sensitivityResult!.riskColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '最敏感因素: ${_sensitivityResult!.mostSensitiveFactor}，建议重点关注',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSensitivityTab() {
    if (_sensitivityResult == null) {
      return const Center(child: Text('请先进行计算'));
    }
    
    final s = _sensitivityResult!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 龙卷风图
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '敏感性分析 (龙卷风图)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...s.sensitivities.map((item) => _buildTornadoBar(item)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 情景分析
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '情景分析',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...s.scenarios.map((scenario) => _buildScenarioRow(scenario)),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 盈亏平衡分析
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '盈亏平衡分析',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ...s.breakEven.criticalMargins.entries.map((e) => 
                    _buildMetricRow('${e.key}可下降空间', e.value)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowTab() {
    if (_result == null) {
      return const Center(child: Text('请先进行计算'));
    }
    
    final data = _result!.yearlyData;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('年份')),
          DataColumn(label: Text('发电量\n(万kWh)')),
          DataColumn(label: Text('收入\n(万元)')),
          DataColumn(label: Text('运维\n(万元)')),
          DataColumn(label: Text('税费\n(万元)')),
          DataColumn(label: Text('净利润\n(万元)')),
          DataColumn(label: Text('净现金流\n(万元)')),
          DataColumn(label: Text('累计现金流\n(万元)')),
        ],
        rows: data.map((y) => DataRow(
          cells: [
            DataCell(Text('${y.year}')),
            DataCell(Text(y.generation.toStringAsFixed(0))),
            DataCell(Text(y.revenue.toStringAsFixed(0))),
            DataCell(Text(y.omc.toStringAsFixed(0))),
            DataCell(Text(y.tax.toStringAsFixed(0))),
            DataCell(Text(y.netProfit.toStringAsFixed(0))),
            DataCell(Text(y.cashFlow.toStringAsFixed(0))),
            DataCell(Text(y.cumulativeCashFlow.toStringAsFixed(0))),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {String? benchmark, bool? isPass}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Row(
            children: [
              if (benchmark != null)
                Text(
                  '($benchmark) ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPass != null
                    ? (isPass ? Colors.green : Colors.red)
                    : Colors.black,
                ),
              ),
              if (isPass != null)
                Icon(
                  isPass ? Icons.check_circle : Icons.warning,
                  color: isPass ? Colors.green : Colors.red,
                  size: 16,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTornadoBar(SensitivityItem item) {
    final maxWidth = MediaQuery.of(context).size.width - 120;
    final scale = 0.5; // 缩放因子
    final positiveWidth = (item.irrAtPlus10 - _sensitivityResult!.baseIRR).abs() * maxWidth * scale;
    final negativeWidth = (item.irrAtMinus10 - _sensitivityResult!.baseIRR).abs() * maxWidth * scale;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(item.name, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: Row(
              children: [
                // 负向变化
                Container(
                  width: negativeWidth,
                  height: 20,
                  color: Colors.red.shade300,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${item.irrAtMinus10.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                // 基准线
                Container(
                  width: 2,
                  height: 24,
                  color: Colors.black,
                ),
                // 正向变化
                Container(
                  width: positiveWidth,
                  height: 20,
                  color: Colors.green.shade300,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${item.irrAtPlus10.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioRow(Scenario scenario) {
    final colors = {
      '乐观': Colors.green,
      '基准': Colors.blue,
      '悲观': Colors.orange,
    };
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: colors[scenario.name],
              ),
              const SizedBox(width: 8),
              Text(scenario.name),
            ],
          ),
          Text('IRR: ${scenario.irr.toStringAsFixed(2)}%'),
          Text('NPV: ${scenario.npv.toStringAsFixed(0)}万'),
          Text('回收期: ${scenario.payback.toStringAsFixed(1)}年'),
        ],
      ),
    );
  }
}
