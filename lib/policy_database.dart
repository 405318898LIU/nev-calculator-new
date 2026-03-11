/// 各省机制电价与政策数据库
/// 数据来源：各省发改委136号文配套文件
class ProvincePolicyDatabase {
  
  static final Map<String, ProvincePolicy> _policies = {
    '贵州': ProvincePolicy(
      name: '贵州',
      benchmarkPrice: 0.3515,
      existingProjectPrice: 0.3515,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '按现行价格政策执行，不高于煤电基准价',
    ),
    '山东': ProvincePolicy(
      name: '山东',
      benchmarkPrice: 0.3949,
      existingProjectPrice: 0.3949,
      newProjectWindPrice: 0.319,
      newProjectPvPrice: 0.225,
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '全国首个落地机制电价省份，首创申报充足率不低于125%规则',
    ),
    '广东': ProvincePolicy(
      name: '广东',
      benchmarkPrice: 0.453,
      existingProjectPrice: 0.453,
      newProjectPriceRange: '0.2-0.453',
      mechanismPeriodOnshore: 12,
      mechanismPeriodOffshore: 14,
      validFrom: '2025-06-01',
      notes: '存量电价全国最高，海上风电执行期14年',
    ),
    '新疆': ProvincePolicy(
      name: '新疆',
      benchmarkPrice: 0.262,
      existingProjectSubsidyPrice: 0.25,
      existingProjectFlatPrice: 0.262,
      newProjectPvPrice: 0.235,
      newProjectWindPrice: 0.252,
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '竞价区间全国最低，鼓励通过跨省交易解决消纳',
    ),
    '蒙东': ProvincePolicy(
      name: '蒙东',
      benchmarkPrice: 0.3035,
      existingProjectPrice: 0.3035,
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '直接绑定当地煤电基准价',
    ),
    '蒙西': ProvincePolicy(
      name: '蒙西',
      benchmarkPrice: 0.2829,
      existingProjectPrice: 0.2829,
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '直接绑定当地煤电基准价',
    ),
    '甘肃': ProvincePolicy(
      name: '甘肃',
      benchmarkPrice: 0.3078,
      existingProjectPrice: 0.3078,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      storageCapacityPrice: 330.0,
      validFrom: '2025-06-01',
      notes: '储能容量电价330元/kW·年，火储同补',
    ),
    '宁夏': ProvincePolicy(
      name: '宁夏',
      benchmarkPrice: 0.2595,
      existingProjectPrice: 0.2595,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      storageCapacityPrice2025: 100.0,
      storageCapacityPrice2026: 165.0,
      validFrom: '2025-06-01',
      notes: '储能容量电价2025年100元，2026年起165元/kW·年',
    ),
    '河北': ProvincePolicy(
      name: '河北',
      benchmarkPrice: 0.3644,
      existingProjectPrice: 0.3644,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      storageCapacityPrice: 100.0,
      validFrom: '2025-06-01',
      notes: '储能容量电价100元/kW·年，先建先得',
    ),
    '江苏': ProvincePolicy(
      name: '江苏',
      benchmarkPrice: 0.391,
      existingProjectPrice: 0.391,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '浙江': ProvincePolicy(
      name: '浙江',
      benchmarkPrice: 0.4153,
      existingProjectPrice: 0.4153,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '上海': ProvincePolicy(
      name: '上海',
      benchmarkPrice: 0.4155,
      existingProjectPrice: 0.4155,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '安徽': ProvincePolicy(
      name: '安徽',
      benchmarkPrice: 0.3844,
      existingProjectPrice: 0.3844,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '河南': ProvincePolicy(
      name: '河南',
      benchmarkPrice: 0.3779,
      existingProjectPrice: 0.3779,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '湖北': ProvincePolicy(
      name: '湖北',
      benchmarkPrice: 0.4161,
      existingProjectPrice: 0.4161,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '湖南': ProvincePolicy(
      name: '湖南',
      benchmarkPrice: 0.45,
      existingProjectPrice: 0.45,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '四川': ProvincePolicy(
      name: '四川',
      benchmarkPrice: 0.4012,
      existingProjectPrice: 0.4012,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '云南': ProvincePolicy(
      name: '云南',
      benchmarkPrice: 0.3358,
      existingProjectPrice: 0.3358,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '陕西': ProvincePolicy(
      name: '陕西',
      benchmarkPrice: 0.3545,
      existingProjectPrice: 0.3545,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '山西': ProvincePolicy(
      name: '山西',
      benchmarkPrice: 0.332,
      existingProjectPrice: 0.332,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '广西': ProvincePolicy(
      name: '广西',
      benchmarkPrice: 0.4207,
      existingProjectPrice: 0.4207,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '江西': ProvincePolicy(
      name: '江西',
      benchmarkPrice: 0.4143,
      existingProjectPrice: 0.4143,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '福建': ProvincePolicy(
      name: '福建',
      benchmarkPrice: 0.3932,
      existingProjectPrice: 0.3932,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '青海': ProvincePolicy(
      name: '青海',
      benchmarkPrice: 0.2277,
      existingProjectPrice: 0.2277,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '全国煤电基准价最低省份',
    ),
    '内蒙古': ProvincePolicy(
      name: '内蒙古',
      benchmarkPrice: 0.2829,
      existingProjectPrice: 0.2829,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '储能补偿标准0.28-0.35元/kWh',
    ),
    '吉林': ProvincePolicy(
      name: '吉林',
      benchmarkPrice: 0.3731,
      existingProjectPrice: 0.3731,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '黑龙江': ProvincePolicy(
      name: '黑龙江',
      benchmarkPrice: 0.374,
      existingProjectPrice: 0.374,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
      notes: '新型储能容量补偿政策研究中',
    ),
    '辽宁': ProvincePolicy(
      name: '辽宁',
      benchmarkPrice: 0.3749,
      existingProjectPrice: 0.3749,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '西藏': ProvincePolicy(
      name: '西藏',
      benchmarkPrice: 0.25,
      existingProjectPrice: 0.25,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '海南': ProvincePolicy(
      name: '海南',
      benchmarkPrice: 0.4298,
      existingProjectPrice: 0.4298,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '天津': ProvincePolicy(
      name: '天津',
      benchmarkPrice: 0.3655,
      existingProjectPrice: 0.3655,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
    '重庆': ProvincePolicy(
      name: '重庆',
      benchmarkPrice: 0.3964,
      existingProjectPrice: 0.3964,
      newProjectMode: '竞价形成',
      mechanismPeriod: 20,
      validFrom: '2025-06-01',
    ),
  };
  
  static List<String> get provinceNames => _policies.keys.toList()..sort();
  
  static ProvincePolicy? getPolicy(String province) => _policies[province];
  
  static double getMechanismPrice(String province, {bool isNewProject = false, String? projectType}) {
    final policy = _policies[province];
    if (policy == null) return 0.3515;
    
    if (isNewProject) {
      if (projectType == '风电' && policy.newProjectWindPrice != null) {
        return policy.newProjectWindPrice!;
      }
      if (projectType == '光伏' && policy.newProjectPvPrice != null) {
        return policy.newProjectPvPrice!;
      }
      return policy.benchmarkPrice * 0.85;
    }
    
    return policy.existingProjectPrice ?? policy.benchmarkPrice;
  }
  
  static List<Map<String, dynamic>> getPriceComparison() {
    return _policies.values.map((p) => {
      'province': p.name,
      'benchmark': p.benchmarkPrice,
      'existing': p.existingProjectPrice ?? p.benchmarkPrice,
      'newMode': p.newProjectMode ?? '竞价形成',
    }).toList();
  }
}

class ProvincePolicy {
  final String name;
  final double benchmarkPrice;
  final double? existingProjectPrice;
  final double? newProjectWindPrice;
  final double? newProjectPvPrice;
  final String? newProjectPriceRange;
  final String? newProjectMode;
  final int? mechanismPeriodOnshore;
  final int? mechanismPeriodOffshore;
  final int mechanismPeriod;
  final double? existingProjectSubsidyPrice;
  final double? existingProjectFlatPrice;
  final double? storageCapacityPrice;
  final double? storageCapacityPrice2025;
  final double? storageCapacityPrice2026;
  final String validFrom;
  final String notes;
  
  ProvincePolicy({
    required this.name,
    required this.benchmarkPrice,
    this.existingProjectPrice,
    this.newProjectWindPrice,
    this.newProjectPvPrice,
    this.newProjectPriceRange,
    this.newProjectMode,
    this.mechanismPeriodOnshore,
    this.mechanismPeriodOffshore,
    this.mechanismPeriod = 20,
    this.existingProjectSubsidyPrice,
    this.existingProjectFlatPrice,
    this.storageCapacityPrice,
    this.storageCapacityPrice2025,
    this.storageCapacityPrice2026,
    required this.validFrom,
    this.notes = '',
  });
}

enum ProjectType {
  groundMountedPV('集中式光伏', 1200, 3.5),
  distributedPV('分布式光伏', 1100, 3.2),
  onshoreWind('陆上风电', 2200, 5.5),
  offshoreWind('海上风电', 3200, 12.0),
  storage('储能电站', 500, 1.5);
  
  final String label;
  final int defaultHours;
  final double defaultUnitCost;
  
  const ProjectType(this.label, this.defaultHours, this.defaultUnitCost);
}

class InvestmentThreshold {
  static const double pvGroundIRR = 6.5;
  static const double pvDistributedIRR = 7.0;
  static const double windOnshoreIRR = 6.5;
  static const double windOffshoreIRR = 6.0;
  static const double storageIRR = 6.0;
  static const double baseIRR = 6.5;
  
  static double getThreshold(ProjectType type) {
    switch (type) {
      case ProjectType.groundMountedPV:
        return pvGroundIRR;
      case ProjectType.distributedPV:
        return pvDistributedIRR;
      case ProjectType.onshoreWind:
        return windOnshoreIRR;
      case ProjectType.offshoreWind:
        return windOffshoreIRR;
      case ProjectType.storage:
        return storageIRR;
    }
  }
}
