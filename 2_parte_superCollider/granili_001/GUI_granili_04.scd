


(
~x = 0;
~arrVal = []!10;
~arrCaixas = Array.fill(10, { nil });
Window.closeAll;
w = Window(bounds:Rect(100,100,430,450))
.background_(Color.fromHexString("014040"))
.alwaysOnTop_(true).front;
w.view.decorator_(FlowLayout(w.view.bounds, 20@20, 10@10));

~x = 10.collect({ |i|
    Slider(w, 160@30)
    .background_(Color.fromHexString("078C8C"))
    .knobColor_(Color.fromHexString("05F2DB"))
    .action_({ |v|
        var val;
        val = v.value;
        //val.postln;
        ~arrVal[i] = val;
        ~arrCaixas[i].value = val;
    });
    ~arrCaixas.put(i, NumberBox(w, 100@30));  // Assign NumberBox to ~arrCaixas
});

)


~arrVal[0].postln