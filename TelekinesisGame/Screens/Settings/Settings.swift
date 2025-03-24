import SwiftUI
import AudioToolbox

struct Settings: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isPresented = false
    
    @State var musicAllowValue: Bool = SoundMusicManager.shared.isAllowedMusic
    @State var soundAllowValue: Bool = SoundMusicManager.shared.isAllowedSounds
    @State var vibrationAllowValue: Bool = SoundMusicManager.shared.isAllowedVibration
    @State private var money: Int = LevelManager.shared.money
    
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: PresentableVcWrapper(),
                    isActive: $isPresented
                ) { EmptyView() }
                Image("settingsBG")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("backButton")
                                .resizable()
                                .frame(width: 56, height: 56)
                        }
                        .padding()
                        Spacer()
                        
                        ZStack {
                            Image("balanceBG")
                                .resizable()
                                .frame(width: 140, height: 44)
                            HStack {
                                Image("coin")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("\(money)")
                                    .font(Font.custom(inAppFontName, size: 16))
                                    .foregroundColor(.white)
                                    .padding(.trailing, 16)
                            }
                        }
                        .padding()
                    }
                    Spacer()
                }
                VStack {
                    
                    VStack(alignment: .center) {
                        HStack(spacing: 30) {
                            Spacer()
                            VStack {
                                Button {
                                    soundAllowValue.toggle()
                                    SoundMusicManager.shared.isAllowedSounds.toggle()
                                } label: {
                                    (soundAllowValue ? Image("soundToggleOn") : Image("soundToggleOff"))
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                }
                                
                                Text("Sound")
                                    .foregroundColor(.blue)
                                    .font(Font.custom(inAppFontName, size: 16))
                            }
                            
                            VStack {
                                Button {
                                    musicAllowValue.toggle()
                                    SoundMusicManager.shared.isAllowedMusic.toggle()
                                    if musicAllowValue {
                                        SoundMusicManager.shared.isAllowedMusic = musicAllowValue
                                        SoundMusicManager.shared.playMenuBackgroundMusic()
                                    } else {
                                        SoundMusicManager.shared.stopPlaying()
                                        SoundMusicManager.shared.isAllowedMusic = musicAllowValue
                                    }
                                } label: {
                                    (musicAllowValue ? Image("musicToggleOn") : Image("musicToggleOff"))
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                }
                                
                                Text("Music")
                                    .foregroundColor(.blue)
                                    .font(Font.custom(inAppFontName, size: 16))
                            }
                            
                            VStack {
                                Button {
                                    vibrationAllowValue.toggle()
                                    SoundMusicManager.shared.isAllowedVibration.toggle()
                                    if vibrationAllowValue {
                                        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
                                    } else {
                                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                    }
                                } label: {
                                    (vibrationAllowValue ? Image("vibrationToggleOn") : Image("vibrationToggleOff"))
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                }
                                
                                Text("Vibration")
                                    .foregroundColor(.blue)
                                    .font(Font.custom(inAppFontName, size: 16))
                            }
                            Spacer()
                        }
                        .padding(.top, 70)
                        Button(action: {
                            withAnimation {
                                isPresented = true
                            }
                        }) {
                            Image("privacyButton")
                                .resizable()
                                .frame(width: 240, height: 56)
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    .background {
                        Image("settingsBlockBG")
                            .resizable()
                            .frame(height: 269)
                            .padding(.horizontal, 20)
                    }
                    .frame(height: 269)
                    .padding(.top, 90)
                    Spacer()
                }
            }
            .statusBarHidden(true)
            .onAppear {
                money = LevelManager.shared.money
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
