import vlc
import time

audio_volume=20

player=vlc.MediaPlayer("")
current_media=vlc.Media("http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p")
player.set_media(current_media)
player.audio_set_volume(audio_volume)
player.play()
time.sleep(60)
player.stop()