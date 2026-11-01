import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/constants/app_constants.dart';
import 'mpin_controller.dart';

class MPINView extends GetView<MPINController> {
  const MPINView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                40,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 28),
                Obx(() => Column(
                      children: [
                        Text(
                          controller.titleText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.subtitleText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 40),
                _buildMpinDots(),
                const SizedBox(height: 12),
                Obx(() => controller.showError.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 18, color: AppColors.error),
                            const SizedBox(width: 6),
                            Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(height: 24)),
                const Spacer(),
                _buildKeypad(context),
                const SizedBox(height: 16),
                Obx(() => controller.currentMode.value == MPINMode.login
                    ? TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot MPIN? Reset App',
                          style: TextStyle(color: colors.textHint, fontSize: 13),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 44,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMpinDots() {
    return Obx(() {
      final length = controller.enteredMPIN.value.length;
      final hasError = controller.showError.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.mpinLength, (index) {
          final isFilled = index < length;
          final activeColor = hasError ? AppColors.mpinError : AppColors.mpinActive;
          final inactiveColor = hasError ? AppColors.mpinError.withOpacity(0.3) : AppColors.mpinInactive;
          return AnimatedContainer(
            duration: AppConstants.animationDuration,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? activeColor : Colors.transparent,
              border: Border.all(
                color: isFilled ? activeColor : inactiveColor,
                width: 2,
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildKeypad(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['1', '2', '3'].map((e) => _buildKey(context, e)).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['4', '5', '6'].map((e) => _buildKey(context, e)).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['7', '8', '9'].map((e) => _buildKey(context, e)).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _EmptyKey(),
              _buildKey(context, '0'),
              _buildKey(context, 'delete', isDelete: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String value, {bool isDelete = false}) {
    final colors = context.colors;
    return Obx(() => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isSubmitting.value ? null : () => controller.onKeypadTap(value),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 72,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDelete ? colors.withdrawalBg : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: isDelete
                  ? Icon(Icons.backspace_outlined, color: colors.withdrawal, size: 26)
                  : Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
            ),
          ),
        ));
  }
}

class _EmptyKey extends StatelessWidget {
  const _EmptyKey();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 72, height: 56);
  }
}
