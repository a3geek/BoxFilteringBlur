ResolutionBlur
===

Ref : [https://github.com/a3geek/ResolutionBlur](https://github.com/a3geek/ResolutionBlur)  
Ref : [https://t-pot.com/program/51_bokashi/index.html](https://t-pot.com/program/51_bokashi/index.html)

段階的に解像度を下げていくぼかし手法は、ダウンサンプリングやアップサンプリングの時にGPU側の処理に依存しているため、あまり綺麗に補間されない。  
そこでボックスフィルタリング手法という、周辺ピクセルの値を参照して平均値を取ってそのピクセルの色とすることで比較的綺麗なぼかしを得ることができる。  

ダウンサンプリングの時はOffsetとして1.0を使うことで1ピクセル隣の4ピクセルを参照させる。  
アップサンプリングの時は1ピクセルを元に4ピクセルの色を決定するため、Offsetとして0.5を使うことで4ピクセルの中心座標となる。  
またサンプリングの時のUVがテクセル（テクスチャの画素、1ピクセルにあたる正方形的な物）中心に乗っていない時はGPU側でバイリニアサンプリングが行われるため、より多くの周辺色を参照できる。

<br />

![Depth Color = RED](./Images/Blur.png)
