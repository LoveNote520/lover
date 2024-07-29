import 'dart:math';

import 'package:flutter/material.dart';

/// Author:      星星
/// CreateTime:  2024/7/29
/// Contact Me:  1395723441@qq.com




class QuarterCircleAnimation extends StatefulWidget {
  const QuarterCircleAnimation({super.key});

  @override
  createState() => _QuarterCircleAnimationState();
}

class _QuarterCircleAnimationState extends State<QuarterCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(200, 200),
            painter: QuarterCirclePainter(_animation.value),
          );
        },
      ),
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final double scale;
// 动画控制器控制大小 scale
  QuarterCirclePainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffED81A5).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * scale;
    // pi =3.14159265359
    final rect = Rect.fromCircle(center: center, radius: radius);
    //2pi是一个圆  四分之一圆就是1/2 pi
    const startAngle = pi; // π radians = 180 degrees   起始角度
    const sweepAngle = pi*3/4; // -π/2 radians = -90 degrees (counter-clockwise) 略过角度

    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class BouncingBallsAnimation extends StatefulWidget {
  final int numberOfBalls;

  const BouncingBallsAnimation({super.key, required this.numberOfBalls});

  @override
  createState() => _BouncingBallsAnimationState();
}

class _BouncingBallsAnimationState extends State<BouncingBallsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Ball> balls;

  @override
  void initState() {
    super.initState();
    ///AnimationController的作用类似于一个计时器，它会在动画周期内按固定的时间间隔产生“滴答”事件。每当产生一个“滴答”事件时，
    ///所有注册的监听器（包括_update方法）都会被调用。这种机制可以用来更新动画的状态，比如移动对象的位置、改变颜色等。
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(_update)
      ..repeat();

    balls = List.generate(widget.numberOfBalls, (index) {
      final rand = Random();
      return Ball(
        x: rand.nextDouble() * 300,
        y: rand.nextDouble() * 300,
        vx: (rand.nextDouble() - 0.5) * 4,//每一帧x 的偏移量
        vy: (rand.nextDouble() - 0.5) * 4,//每一帧y 的偏移量
        radius: 20,
        color: Color.fromARGB(
          255,
          rand.nextInt(256),
          rand.nextInt(256),
          rand.nextInt(256),
        ),
      );
    });
  }
  void _update() {
    setState(() {
      // 更新球位
      for (var ball in balls) {
        // 根据每个小球的速度更新它们的位置
        ball.x += ball.vx;
        ball.y += ball.vy;

        // 检查与墙壁的碰撞,检查每个小球是否碰撞到画布的边界，并在发生碰撞时反转小球的速度(的偏移量 原本是 每一帧是 +vx，碰撞后每一帧-vx)，使其“弹回”到画布内部：
        if (ball.x - ball.radius < 0 || ball.x + ball.radius > 300) ball.vx = -ball.vx;
        if (ball.y - ball.radius < 0 || ball.y + ball.radius > 300) ball.vy = -ball.vy;
      }

      // 检查与其他球的碰撞 检查是否发生碰撞（即距离小于两个小球半径之和）。
      for (var i = 0; i < balls.length; i++) {
        //碰撞处理
        // 处理碰撞时，需要做以下几件事情：
        //
        // 清除重叠:
        //
        // 计算并处理小球之间的重叠，确保它们不再重叠。
        // 计算碰撞后的速度:
        //
        // 使用弹性碰撞公式计算碰撞后的速度，并更新小球的速度。
        //dx 和 dy: 计算两个小球中心的 x 和 y 轴距离。
        // distance: 计算两小球中心之间的实际距离。
        // distance < ball1.radius + ball2.radius: 检查是否发生碰撞（即距离小于两个小球半径之和）。

        for (var j = i + 1; j < balls.length; j++) {
          final ball1 = balls[i];
          final ball2 = balls[j];

          double dx = ball2.x - ball1.x;
          double dy = ball2.y - ball1.y;
          double distance = sqrt(dx * dx + dy * dy);

          if (distance < ball1.radius + ball2.radius) {
            // 计算重叠
            //overlap: 计算两个小球之间的重叠量。
            // nx 和 ny: 计算碰撞方向的单位向量。
            // correction: 计算需要移动的距离以消除重叠。
            // dotProduct: 计算两个小球相对速度在碰撞轴上的分量。
            // coefficient: 用于处理动量和能量的弹性碰撞系数（在这个示例中，假设两个小球的质量相等）。
            double overlap = ball1.radius + ball2.radius - distance;

            // 规范化碰撞矢量
            double nx = dx / distance;
            double ny = dy / distance;

            // 将球移出重叠区域
            double correction = overlap / 2;
            ball1.x -= correction * nx;
            ball1.y -= correction * ny;
            ball2.x += correction * nx;
            ball2.y += correction * ny;

            // 用弹性碰撞公式计算新速度
            double v1x = ball1.vx;
            double v1y = ball1.vy;
            double v2x = ball2.vx;
            double v2y = ball2.vy;

            double dotProduct = (v1x - v2x) * nx + (v1y - v2y) * ny;

            // 为简单起见，使用等质量假设
            double coefficient = 2.0 / 2.0; // ball1和ball2的质量相等

            ball1.vx -= coefficient * dotProduct * nx;
            ball1.vy -= coefficient * dotProduct * ny;
            ball2.vx += coefficient * dotProduct * nx;
            ball2.vy += coefficient * dotProduct * ny;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(300, 300),
        painter: BouncingBallsPainter(balls),
      ),
    );
  }
}

class Ball {
  double x, y;
  double vx, vy;
  double radius;
  Color color;

  Ball({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
  });
}
//画个圆

class BouncingBallsPainter extends CustomPainter {
  final List<Ball> balls;

  BouncingBallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var ball in balls) {
      paint.color = ball.color;
      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
