class TurkishTaxHelper {
  // Calculates total monthly deduction percentage
  // based on 2024 Turkish tax brackets
  static double calculateMonthlyDeductionRate({
    required double grossNormal,
    required double grossOvertime,
    required String hireDateStr,
    required int currentMonth,
    required int currentYear,
  }) {
    // 15% Social Security + Unemployment deduction
    const double sgkRate = 0.15;
    
    // Calculate cumulative tax base up to current month
    double monthlyTaxBase = (grossNormal + grossOvertime) * (1.0 - sgkRate);
    double cumulativeBase = monthlyTaxBase * (currentMonth - 1);
    double newCumulativeBase = cumulativeBase + monthlyTaxBase;

    // 2024 Income tax brackets
    double taxRate = 0.15;
    if (newCumulativeBase > 3000000) {
      taxRate = 0.40;
    } else if (newCumulativeBase > 580000) {
      taxRate = 0.35;
    } else if (newCumulativeBase > 230000) {
      taxRate = 0.27;
    } else if (newCumulativeBase > 110000) {
      taxRate = 0.20;
    }

    return (sgkRate + taxRate) * 100.0; // Return as percentage e.g. 30.0 for 30%
  }

  static double calculateNetSalary(double gross, double taxPct) {
    return gross * (1.0 - (taxPct / 100.0));
  }
}
