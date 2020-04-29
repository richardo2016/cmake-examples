## @autoreleasepool

我开始学 objc 的时候用这个例子:

```objectivec
#import <Cocoa/Cocoa.h>

int main ()
    {
        @autoreleasepool{
            [NSApplication sharedApplication];
            [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
            id applicationName = [[NSProcessInfo processInfo] processName];
            id window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 120, 120)
                styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
            [window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
            [window setTitle: applicationName];
            [window makeKeyAndOrderFront:nil];
            [NSApp activateIgnoringOtherApps:YES];
            [NSApp run];
        }
        return 0;
}
```

看名字, `@autoreleasepool` 应该是管理了某种资源的资源池.

查一查:

- https://stackoverflow.com/questions/17777043/objective-c-autoreleasepool

这个答案里有人说:

[Using Autorelease Pool Blocks]:http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html

> 可以看一看苹果讨论区在 _Advanced Memory Management Programming Guide_ 上的 [Using Autorelease Pool Blocks].
>
> 简单来说, 它(`@autoreleasepool`)的含义并不是"在程序结束时自动释放被包裹在 `@autoreleasepool` 中的所有东西"(甚至这也不是 `@autoreleasepool` 的功能). 这东西存在的目的是控制从自动释放的内容中重新声明的内存, 比如, 如果这个资源池快要枯竭. 不过, 在你这个例子(#译者注: 指回答里的那个例子)好像没用到任何会自动释放的内容, 所以在这里 `@autoreleasepool` 并没有什么用(除非你例子里的方法内部使用了自动释放的对象).
>
> autorelease pools 最常见的用法是降低你应用里可能出现的内存高水位(译者注: 即内存使用过高). 看这篇 [See Use Local Autorelease Pool Blocks to Reduce Peak Memory Footprint](http://developer.apple.com/library/ios/documentation/cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html#//apple_ref/doc/uid/20000047-SW2). 这项技术过去被用于[跨线程编程](http://developer.apple.com/library/ios/documentation/cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html#//apple_ref/doc/uid/20000047-1041876-CJBFEIEG), 不过现在我们有了 operation 和 dispatch blocks(#译者注: 也许有点像 flux 思想里的 action 和 dispatch), 我们不必像以前那样写跨线程代码, 所以我们也不太容易碰到必须要在我们的多线程代码中使用 autorelease pools 的地方.

那我们来看看这个 [Using Autorelease Pool Blocks], 记录在[另一篇](./2.1-using-autorelease-pool-blocks.md)中.