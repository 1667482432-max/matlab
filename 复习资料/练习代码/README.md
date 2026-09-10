# 练习代码使用说明

在 MATLAB 中将当前文件夹设为本目录。**先运行 `lesson00_language.m` 学纯基础语法，再按《03_4天冲刺计划.md》进入画图、信号和系统，无需每个文件都学完。** 每个脚本可以独立运行并在开头清理变量；绘图练习还会关闭旧图。`lesson05_allpass.m` 会调用同目录的 `f_allpass.m`；`lesson06_convolution.m` 会调用 `conv1.m`；`lesson07_spectrum.m` 会调用 `prefourier.m`。

这些是为本次复习新写的教学练习。第3、5课需要 Signal Processing Toolbox；第4课需要 Control System Toolbox。工具箱函数的写法与课件一致。

| 文件 | 练什么 | 能肉眼/手算核对的结果 |
|---|---|---|
| lesson00_language.m | 变量、数组、下标、条件、循环与函数；无绘图 | 商品总价34，1到10之和55，平方结果[4 9 16] |
| lesson01_basics.m | 时间轴、点乘、正弦 | 101点、1秒3周期、衰减包络 |
| lesson02_signals.m | 条件、循环、子图 | 矩形在n=0,1,2,3为1 |
| lesson03_discrete.m | 系数、filter、工具箱作图 | `impz` 单位样值响应、`freqz` 频响、`zplane` 零极点图 |
| lesson04_continuous.m | 连续系统的标准工具箱写法 | 从微分方程写 `tf`，用 `lsim`、`impulse`、`step` 求响应 |
| lesson05_allpass.m | 函数、全通、九宫格 | `zp2tf` 建系数；幅频常数108/13；9组各60点 |
| lesson06_convolution.m | 两类卷积、补零FFT | 用课件 `conv1`；离散结果[1 1 -1 -1] |
| lesson07_spectrum.m | Hz与角频率、幅度谱 | 用课件 `prefourier`；双边2Hz分量高0.5，8Hz分量高0.25 |
| lesson08_sampling.m | 抽取、混叠 | 20Hz采样下3Hz与77Hz余弦相同；100Hz二抽一变50Hz |

每课完成：跟写 → 改参数 → 遮住答案重写 → 检查。第4课现在直接使用已安装的 Control System Toolbox；重点记住“微分方程系数 → `tf` → `lsim/impulse/step`”这条考试写法。

验证记录：2026-09-08，8 个练习均已在本机 MATLAB R2024a 中实际运行通过。核对包括手算响应/独立递推、连续系统解析解、全通幅频常数、卷积与 FFT 的一致性、频谱峰值及能量关系、采样混叠关系；并查看了连续响应、九宫格与频谱的输出图。Control System Toolbox 安装后，第4课已改用课件的标准写法；修改参数后的结果需要你重新检查。
