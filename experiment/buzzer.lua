local R = 0

local C3  = 131
local CS3 = 139
local D3  = 147
local DS3 = 156
local E3  = 165
local F3  = 175
local FS3 = 185
local G3  = 196
local GS3 = 208
local A3  = 220
local AS3 = 233
local B3  = 247

local C4  = 262
local CS4 = 277
local D4  = 294
local DS4 = 311
local E4  = 330
local F4  = 349
local FS4 = 370
local G4  = 392
local GS4 = 415
local A4  = 440
local AS4 = 466
local B4  = 494

local C5  = 523
local CS5 = 554
local D5  = 587
local DS5 = 622
local E5  = 659
local F5  = 698
local FS5 = 740
local G5  = 784
local GS5 = 831
local A5  = 880
local AS5 = 932
local B5  = 988

local song = {
  E5, E5, 0, E5,
  0, C5, E5, 0,
  G5, 0, 0,  0,
  G4, 0, 0, 0,

  C5, 0, 0, G4,
  0, 0, E4, 0,
  0, A4, 0, B4,
  0, AS4, A4, 0,

  G4, E5, G5,
  A5, 0, F5, G5,
  0, E5, 0, C5,
  D5, B4, 0, 0,

  C5, 0, 0, G4,
  0, 0, E4, 0,
  0, A4, 0, B4,
  0, AS4, A4, 0,

  G4, E5, G5,
  A5, 0, F5, G5,
  0, E5, 0, C5,
  D5, B4, 0, 0,

  --
  0,
  --

  C4, C5, A3, A4,
  AS3, AS4, 0,
  0,
  C4, C5, A3, A4,
  AS3, AS4, 0,
  0,
  F3, F4, D3, D4,
  DS3, DS4, 0,
  0,
  F3, F4, D3, D4,
  DS3, DS4, 0,
  0, DS4, CS4, D4,
  CS4, DS4,
  DS4, GS3,
  G3, CS4,
  C4, FS4, F4, E3, AS4, A4,
  GS4, DS4, B3,
  AS3, A3, GS3,

  --
  0
  --
}

local tempo = {
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  --
  100,
  --

  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  3,
  12, 12, 12, 12,
  12, 12, 6,
  6, 18, 18, 18,
  6, 6,
  6, 6,
  6, 6,
  18, 18, 18, 18, 18, 18,
  10, 10, 10,
  10, 10, 10,

  --
  100
  --
}

local song3 = {
  D4, 0, F4, 0, D5, 0, D4, 0,
  F4, 0, D5, 0, E5, 0, F5, 0,
  E5, 0, F5, 0, E5, 0, C5, 0,
  A4, 0, A4, 0, D4, 0, F4, 0,
  G4, 0, A4, 0, A4, 0, D4, 0,
  F4, 0, G4, 0, E4, 0, D4, 0,
  F4, 0, D5, 0, D4, 0, F4, 0,
  D5, 0, E5, 0, F5, 0, E5, 0,
  F5, 0, E5, 0, C5, 0, A4, 0,
  A4, 0, D4, 0, F4, 0, G4, 0,
  A4, 0, A4, 0, D4, 0
}

local tempo4 = {
  100, 80, 100, 80, 200, 250, 100, 80,
  100, 80, 200, 250, 200, 200, 100, 100,
  100, 80, 100, 80, 100, 80, 100, 80,
  100, 300, 200, 100, 200, 100, 100, 100,
  100, 100, 100, 500, 200, 100, 200, 100,
  100, 100, 100, 100, 100, 500, 100, 80,
  100, 80, 200, 250, 100, 80, 100, 80,
  200, 250, 200, 200, 100, 100, 100, 80,
  100, 80, 100, 80, 100, 80, 100, 300,
  200, 100, 200, 100, 100, 100, 100, 100,
  300, 100, 200, 100, 300, 2000
}

local song = {
  G4, R, G4, R, G4, R, DS4, R, AS4, R, G4, R, DS4, R, AS4, R, G4, R,
  D5, R, D5, R, D5, R, DS5, R, AS4, R, FS4, R, DS4, R, AS4, R, G4, R,
  G5, R, G4, R, G4, R, G5, R, FS5, R, F5, R, E5, R, DS5, R, E5, R,
  R, R, G4, R, R, R, CS5, R, C5, R, B4, R, AS4, R, A4, R, AS4, R,
  R, R, DS4, R, R, R, FS4, R, DS4, R, AS4, R, G4, R, DS4, R, AS4, R, G4, R
}

local tempo = {
  75, 5, 75, 5, 75, 5, 55, 5, 25, 5, 75, 5, 55, 5, 15, 5, 155, 5,
  75, 5, 75, 5, 75, 5, 55, 5, 15, 5, 75, 5, 55, 5, 15, 5, 155, 5,
  75, 5, 55, 5, 15, 5, 75, 5, 55, 5, 15, 5, 15, 5, 15, 5, 15, 5,
  55, 5, 15, 5, 15, 5, 75, 5, 55, 5, 15, 5, 15, 5, 15, 5, 15, 5,
  55, 5, 15, 5, 15, 5, 95, 5, 55, 5, 15, 5, 75, 5, 55, 5, 15, 5, 155, 500
}

local song2 = {
  A4, R, A4, R,
  A4, R, F4, R,
  C5, R, A4, R,

  F4, R, C5, R,
  A4, R, E5, R,
  E5, R, E5, R,

  F5, R, C5, R,
  G5, R, F5, R,
  C5, R, A4, R
}

local tempo2 = {
  50, 20, 50, 20,
  50, 20, 40, 5,

  20, 5,  60, 10,

  40, 5, 20, 5,
  60, 80, 50, 20,
  50, 20, 50, 20,

  40, 5, 20, 5,
  60, 10, 40, 5,
  20, 5, 60, 400
}

local song2 = {
  F4, F4, F4, AS4,
  F5, DS5, D5, C5,
  AS5, F5, DS5, D5,
  C5, AS5, F5, DS5,
  D5, DS5, C5, 0
}

local tempo2 = {
  21, 21, 21, 128,
  128, 21, 21, 21,
  128, 64, 21, 21,
  21, 128, 64, 21,
  21, 21, 128, 50
}
-- local song = song2
-- local tempo = tempo2
-- local song = {C5,G5,E5,A5,B5,As5,A5,G5,E5,G5,A5,F5,G5,E5,C5,D5,B5}
local song_pos = 1

duty = 128

function makeNoise()
  -- print(#song)
  -- print(#tempo)

  local cycle = (song[song_pos])
  local delay = (tempo[song_pos]*10)

  if cycle ~= 0 and cycle ~= nil then
    pwm.setup(4,cycle,duty)
    pwm.start(4)
  else
    pwm.setup(4,1,0)
    pwm.start(4)
  end

  song_pos = song_pos+1
  if (song_pos > #song) then
    -- print("restart song "..song_pos..":"..cycle)
    song_pos = 1
  end

  tmr.alarm(0, delay, 0, makeNoise )

end

tmr.alarm(0, 1, 0, makeNoise )
