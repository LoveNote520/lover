import 'package:flutter/material.dart';

/// Author:      星星
/// CreateTime:  2024/7/29
/// Contact Me:  1395723441@qq.com


class Dome extends StatefulWidget {
  const Dome({Key? key}) : super(key: key);

  @override
  State<Dome> createState() => _DomeState();
}

class _DomeState extends State<Dome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w), child: CustomTextField(hintText: "用户名", isPassword: true)),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            child: CustomTextField(hintText: "用户名", isVerificationCode: true)),
        CustomTextField(
          hintText: "请输入密码",
          isPassword: true,
          onChanged: (value) {
            print("密码: $value");
          },
          // validator: (value) {
          //   if (value == null || value.length < 6) {
          //     return "密码长度不能少于6位";
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isVerificationCode;
  final VoidCallback? onGetVerificationCode;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isVerificationCode = false,
    this.onGetVerificationCode,
    this.onChanged,
    this.validator,
  });

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: widget.isPassword ? _obscureText : false,
              onChanged: (value) {
                setState(() {
                  _errorText = widget.validator?.call(value);
                });
                widget.onChanged?.call(value);
              },
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: const Color(0xff969696), fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 26.w, right: 16, top: 16.w, bottom: 16.w),
                  alignLabelWithHint: true,
                  suffixIcon: _buildSuffixIcon()),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  _errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ));
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.isVerificationCode) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28.w,
            child: const VerticalDivider(
              color: Color(0xffD9D9D9),
              thickness: 2,
              width: 2,
            ),
          ),
          TextButton(
            onPressed: widget.onGetVerificationCode,
            child: Text(
              "获取验证码",
              style: TextStyle(color: const Color(0xffED81A5), fontSize: 14.sp),
            ),
          ),
        ],
      );
    }
    return null;
  }
}
