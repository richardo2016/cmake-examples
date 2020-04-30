## 和运行时交互

### keywords

- [Messaging]
- [Defining a Class]
- [Protocols]

Objective-C 程序和运行时的交互发生在三种不同的层次上: 经由 Objective-C 源代码; 经由定义在 Foundation 框架中的 NSObject 类上的方法; 经由对运行时方法的直接调用.

### Objective-C 源代码

通常, 运行时系统会自动运行, 默默工作在幕后. 你得靠编写并编译 Objective-C 源代码来使用操纵它.

当你编译包含了 Objective-C 类和方法的代码时, 编译器为了得到了语言的动态字节码, 会创建一些数据结构和函数调用. 这些数据结构捕捉到了这些信息: 类和分类定义(class and category definitions)里能找到的信息, 以及协议声明(protocol declartions)中能找到的信息. 这些信息包括类(class)和协议(protocol)对象, 这部分知识在 [Objective-C Programming Language] 的 [Defining a Class] 和 [Protocols] 能找到, 同时这些信息还包含了方法选择器(method selectors), 实例变量模板(instance variable templates), 以及其它从源代码里提取到的信息. 最重要(principal)的运行时方法是"发送消息", 该动作由 [Messaging] 这一节描述, 它由源代码中的消息表达式(message expression)所调用.

**译者注** 这里的消息表达式可能是指 `[obj autorelease]` 这种表达式.

### NSObject 上的方法

[Message Forwarding]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html#//apple_ref/doc/uid/TP40008048-CH105-SW1码.

Cocoa 中大部分的对象都属于 `NSObject` 类的子类, 所以大部分对象都继承了其定义的方法. (但一些比较值得注意的例外是 NSProxy 类; 参考 [Message Forwarding] 以获得更多详情) 它上面的方法由此构成了每个实例和每个类对象上的固有行为. 然而, 在少部分场景中, `NSObject` 类只是定义了一个模板, 以表达某件事会如何完成; 这种情况下它不提供所有必要的(necessary)代

举个例子, `NSObject` 类定义了一个名为 `description` 的实例方法, 它只返回一个描述了该类内容的字符串. 这种能力起初被用于调试 —— GDB 的 `print-object` 命令会打印出从该方法返回的字符串. `NSObject` 对该方法的实现中并不知道这个类里包含了什么, 因此它返回了一个具名的字符串和这个对象的内存地址. `NSObject` 的子类可以实现该方法以返回更多的细节. 比如, Foundation 框架中的类 `NSArray` 可以返回了一系列其所包含的对象的描述.

一些 `NSObject` 上的方法只是简单地查询运行时系统中的信息. 这些方法允许对象进行自检(introspection). 这样的方法有比如 `class` 方法, 它会询问一个对象其所属的类; `isKindOfClass:` 和 `isMemberOfClass:`, 用于检测一个对象再继承层级里面的位置; `respondsToSelector:` 用于标明一个对象是否可以接收某种特定的消息; `conformsToProtocol:`, 用于标明是否一个对象宣称实现了在某个具体的 `protocl` 中的方法; 还有 `methodForSelector:`, 其提供了该方法实现的内存地址. 像这样的方法给了对象检查自身情况的能力.

**译者注**: 自检(introspection) 似乎和反射(reflection) 有关.

[Defining a Class]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocDefiningClasses.html#//apple_ref/doc/uid/TP30001163-CH12
[Protocols]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocProtocols.html#//apple_ref/doc/uid/TP30001163-CH15
[Objective-C Programming Language]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html#//apple_ref/doc/uid/TP30001163
[Messaging]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1

### 运行时方法

[Objective-C Runtime Reference]:https://developer.apple.com/documentation/objectivec/objective_c_runtime

运行时系统是一个动态链接库, 提供了一些列由方法和数据结构组成的公开接口, 这些方法和数据结构所在的头文件都存放在 `/usr/include/objc`. 大部分方法允许你使用纯 C 来复现编译器编译你写的 Objective-C 代码时做的事情. 其它方法则构成了 `NSObject` 类上对外暴露的基础功能. 这些方法使得用户可以开发其它接入运行时系统的接口, 并生产能扩展开发环境的工具; 这些 API 在你使用 Objective-C 的时候并非必需. 不过, 一些运行时方法可能在写一个 Objective-C 程序的时候偶尔有用. 所有的这些方法都可在 [Objective-C Runtime Reference] 查到.

## 原文

https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtInteracting.html#//apple_ref/doc/uid/TP40008048-CH103-SW1