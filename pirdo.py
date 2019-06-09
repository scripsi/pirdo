import vlc

player=vlc.MediaPlayer()
player.set_media(http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p)
player.audio_set_volume(20)
player.play()