## 运行时的版本和平台

存在几种不同版本的运行在不同平台上的 Objective-C 运行时.

### 兼容版和现代版

现存有两种版本的 Objective-C 运行时 —— "现代的" 和 "兼容的". 现代版自 Objective-C 2.0 时引入, 包含了一系列相对新的特性. 兼容版本运行时的编程接口在 _Objective-C 1 Runtime Reference_ 中有所描述; 现代版本运行时的接口则在 _[Objective-C Runtime Reference]_ 中.

[Objective-C Runtime Reference]:https://developer.apple.com/documentation/objectivec/objective_c_runtime

现代版运行时引入的最显著的特性新特性是, 实例变量不再"脆弱易碎"(non-fragile):

- 在兼容版运行时中, 如果你改变了一个类的构造, 你**必须**重新编译所有继承自它的类.
- 在现代版运行时中, 如果你改变了一个类的构造, 你**不必**重新编译所有继承自它的类.

此外, 现代版运行时支持对于已声明的属性(properties)实例变量进行组合(synthesis). (详见 [The Objective-C Programming Language] 中的 [Declared Properties])

[The Objective-C Programming Language]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html#//apple_ref/doc/uid/TP30001163

[Declared Properties]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocProperties.html#//apple_ref/doc/uid/TP30001163-CH17

### 平台

iPhone 应用和 OS X v10.5 及其以后的 64 位程序使用现代版运行时.

其他程序(OS X 桌面上的 32 位程序) 使用兼容版运行时.

## 原文

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html#//apple_ref/doc/uid/TP40008048-CH106-SW1