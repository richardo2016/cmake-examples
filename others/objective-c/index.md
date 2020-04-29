## 入门

[苹果开发者 obj-c 入门](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048)

> 重要通知: 该文档已不再更新. 关于 Apple SDK 的最新消息, 请访问[文档网站](https://developer.apple.com/documentation).

**译者注** 真是开幕雷击...不过为了了解 objectivec 的历史, 还是先看这个, 然后需要最新 API 再去看新网站

无论是编译时还是链接时, Objective-C 语言会推迟其语言行为. 在任何可能的地方, 它都动态化地处理一些. 这意味着这门语言不仅要求有个编译器, 还需要一个运行时系统来执行编译后的代码. 这个运行时系统在一定程度上就是 Objective-C 语言自己的操作哦系统; 它使得这门语言能工作起来.

本文档着眼于 `NSObject` 类, 以及 Objective-C 程序如何与运行时系统交互. 尤为重要的一点是, 本文档会说明一种范式: 在运行时动态加载一个新的类的范式然后分发消息给其它对象(译者注: NSObject 的对象). 本文还提供了文档供你查阅这些对象要如何在你的程序中工作.

你应该阅读这份文档以理解 Objective-C 的运行时系统是如何工作的, 并且习得你如何良好使用它们的技巧. 一般来说, 为了写好一个 Cocoa 应用, 你需要熟知这些材料.

### 文档结构

本文档分为以下章节:

- [Runtime Versions and Platforms](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html#//apple_ref/doc/uid/TP40008048-CH106-SW1)
- [Interacting with the Runtime](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtInteracting.html#//apple_ref/doc/uid/TP40008048-CH103-SW1)
- [Messaging](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1)
- [Dynamic Method Resolution](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1)
- [Message Forwarding](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html#//apple_ref/doc/uid/TP40008048-CH105-SW1)
- [Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
- [Declared Properties](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW1)

### 附录

[Objective-C Runtime Reference]:https://developer.apple.com/documentation/objectivec/objective_c_runtime

[Objective-C Runtime Reference] 描述了 Objective-C 运行时库中的数据结构和方法. 你的程序可以使用这些接口和 Objective-C 运行时系统进行交互. 比如, 你可以添加类或者方法, 或者获得所有已经加载了的类的定义.

[Programming With Objective-C]:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011210

[Programming With Objective-C] 描述了 Objective-C 语言本身的特性.

[Objective-C Release Notes]:https://developer.apple.com/library/archive/releasenotes/Cocoa/RN-ObjectiveC/index.html#//apple_ref/doc/uid/TP40004309

[Objective-C Release Notes] 记录了近来 OS X 发行版中 Objective-C 运行时中的一些变化.