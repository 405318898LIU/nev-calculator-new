import 'package:flutter/material.dart';
import 'calculation_engine.dart';
import 'policy_database.dart';
import 'sensitivity_agent.dart';

/// ProjectParams扩展 - 添加copyWith方法
extension ProjectParamsCopyWith on ProjectParams {
  ProjectParams copyWith({
    double? totalInvestment,
    int? constructionPeriod,
    int? operationPeriod,
    double? capacity,
    double? utilizationHours,
    double? degradationRate,
    double? annualDegradation,
    double? mechanismPrice,
    double? mechanismRatio,
    int? mechanismPeriod,
    double? marketPrice,
    double? marketRatio,
    double? greenPrice,
    double? omcPerW,
    double? insuranceRate,
    double? taxRate,
    double? depreciationYears,
    double? discountRate,
    double? equityRatio,
    double? loanRate,
    int? loanTerm,
  }) {
    return ProjectParams(
      totalInvestment: totalInvestment ?? this.totalInvestment,
      constructionPeriod: constructionPeriod ?? this.constructionPeriod,
      operationPeriod: operationPeriod ?? this.operationPeriod,
      capacity: capacity ?? this.capacity,
      utilizationHours: utilizationHours ?? this.utilizationHours,
      degradationRate: degradationRate ?? this.degradationRate,
      annualDegradation: annualDegradation ?? this.annualDegradation,
      mechanismPrice: mechanismPrice ?? this.mechanismPrice,
      mechanismRatio: mechanismRatio ?? this.mechanismRatio,
      mechanismPeriod: mechanismPeriod ?? this.mechanismPeriod,
      marketPrice: marketPrice ?? this.marketPrice,
      marketRatio: marketRatio ?? this.marketRatio,
      greenPrice: greenPrice ?? this.greenPrice,
      omcPerW: omcPerW ?? this.omcPerW,
      insuranceRate: insuranceRate ?? this.insuranceRate,
      taxRate: taxRate ?? this.taxRate,
      depreciationYears: depreciationYears ?? this.depreciationYears,
      discountRate: discountRate ?? this.discountRate,
      equityRatio: equityRatio ?? this.equityRatio,
      loanRate: loanRate ?? this.loanRate,
      loanTerm: loanTerm ?? this.loanTerm,
    );
  }
}
