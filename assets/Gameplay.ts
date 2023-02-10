import { _decorator, Component, Node, native, Label, AudioClip, assetManager, AudioSource, sys } from "cc";
const { ccclass, property } = _decorator;

@ccclass("Gameplay")
export class Gameplay extends Component {
    @property({ type: Label })
    startBtn: Label = null;
    @property({ type: Label })
    stopBtn: Label = null;
    audioPath: string = null;
    start() {}
    startButton() {
        // // Native call android and ios
        // /**
        //  * @description check device os
        //  */
        // // if (sys.os === sys.OS.IOS) {
        // //     console.log("ios device");s
        // //     var ret = native.reflection.callStaticMethod(
        // //         "AppDelegate",
        // //         "callNativeUIWithTitle:andContent:",
        // //         "cocos2d-js",
        // //         "Yes! you call a Native UI from Reflection"
        // //     );
        // // } else if (sys.os === sys.OS.ANDROID) {
        // //     console.log("android app");

        // //     native.reflection.callStaticMethod(
        // //         "com/cocos/game/AppActivity",
        // //         "startRecording",
        // //         "(Ljava/lang/String;)V",
        // //         "start"
        // //     );
        // // }
        var ret = native.reflection.callStaticMethod(
            "AppDelegate",
            "callNativeUIWithTitle:andContent:",
            "cocos2d-js",
            "Yes! you call a Native UI from Reflection"
        );
        if (ret) console.log("START Method Called");
        console.log(ret);
        this.audioPath = ret;
        this.startBtn.string = "RECORDING";
    }

    stopButton() {
        var st = native.reflection.callStaticMethod(
            "AppDelegate",
            "callNativeUI:andContent:",
            "cocos2d-js",
            "Yes! you call a Native UI from Reflection"
        );

        if (st) console.log("STOP Method Called");

        this.stopBtn.string = "STOPPED";
    }
    playAudioBtn() {
        let absolutePath2 = this.audioPath;
        // var audioFile: AudioClip = null;
        assetManager.loadRemote<AudioClip>(
            absolutePath2,
            { audioLoadMode: AudioClip.AudioType.NATIVE_AUDIO },
            (err, audioClip) => {
                console.log("PATH", absolutePath2);
                if (err) {
                    console.log("ERROR");
                    console.log(JSON.stringify(err));
                    return;
                }
                // audioFile = audioClip;
                console.log("CLIP", audioClip);
                this.node.getComponent(AudioSource).clip = audioClip;
                this.node.getComponent(AudioSource).play();
            }
        );
    }
    stopAudioBtn() {
        var ret = native.reflection.callStaticMethod(
            "AppDelegate",
            "deleteFile:andContent:",
            `${this.audioPath}`,
            "Yes! you call a Native UI from Reflection"
        );
        if (ret) {
            console.log("audio delete if ");
            this.node.getComponent(AudioSource).clip = null;
        }
        console.log("audio delete");
    }
    update(deltaTime: number) {}
}
