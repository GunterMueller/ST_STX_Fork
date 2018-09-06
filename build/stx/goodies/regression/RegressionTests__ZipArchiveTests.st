"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ZipArchiveTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression'
!


!ZipArchiveTests methodsFor:'tests'!

badZipArchiveDataFile
    ^ #[80 75 3 4 20 0 0 0 8 0 218 62 46 62 215 233 78 110 174 11 0 0 207 84 0 0 7 0 17 0 115 116
114 46 100 97 116 85 84 13 0 7 37 1 48 77 37 1 48 77 37 1 48 77 237 92 109 115 162 200 22 254 190
85 243 31 250 219 222 189 153 25 233 230 69 116 63 33 96 164 70 193 11 152 151 91 84 221 66 197 232
14 209 44 144 201 78 77 205 127 191 167 155 6 209 160 73 106 204 214 212 134 173 29 133 230 156 231
188 62 167 73 130 126 11 146 108 129 131 112 157 174 130 121 180 136 195 245 141 40 168 56 88 100
235 233 31 193 253 12 211 213 133 240 238 151 111 193 98 179 206 178 105 12 7 2 10 22 233 195 42 77
145 150 172 194 248 247 239 176 134 97 45 217 220 134 107 120 159 45 195 36 141 50 130 252 213 109
148 34 59 122 64 46 189 196 4 73 157 160 247 245 118 186 201 129 196 18 188 188 46 212 2 73 117 130
253 228 62 91 221 68 9 146 100 52 92 221 44 51 38 42 131 200 122 21 35 125 115 159 172 224 34 0 177
117 133 175 15 239 103 171 121 136 60 72 195 239 223 191 211 96 103 155 120 147 64 180 232 247 32
137 230 68 150 131 155 36 138 214 244 96 26 223 71 240 158 95 17 242 117 129 173 10 59 107 138 196
22 49 81 107 68 113 91 169 89 37 120 23 130 175 22 198 30 185 113 0 91 1 20 22 69 154 125 141 163
116 25 69 25 4 155 18 33 152 45 72 48 155 226 96 182 156 77 239 194 12 35 123 147 220 230 21 156 165
80 117 124 64 204 136 22 225 125 156 161 113 152 132 55 73 120 183 68 125 232 6 170 150 146 32 93 71
127 101 2 87 86 131 233 99 117 223 209 17 102 210 226 174 180 84 35 29 44 86 66 16 175 176 42 4 201
74 96 186 132 233 74 251 186 7 52 69 101 171 41 50 77 249 153 154 178 180 213 148 152 166 242 76 205
54 217 106 202 239 126 97 186 237 103 234 118 132 173 174 194 52 213 103 106 98 161 146 164 54 83 237
60 87 149 84 178 164 50 85 44 60 87 87 170 228 169 147 235 226 66 119 115 159 197 171 117 20 71 95
162 24 144 224 255 84 36 172 204 226 46 86 58 37 0 147 134 224 71 26 239 233 161 65 20 206 87 235 27
222 53 184 108 178 170 20 230 232 2 67 151 158 141 142 75 116 194 43 133 203 182 172 202 145 28 159
183 180 252 108 124 82 226 231 221 135 203 198 173 74 137 28 61 167 192 243 115 35 150 232 121 135
226 178 185 171 82 82 5 125 245 34 124 169 196 151 115 252 146 2 85 41 153 227 191 180 178 114 137
174 20 185 47 105 82 149 83 74 252 251 248 69 6 148 210 64 206 7 92 114 169 42 213 230 240 2 133 167
249 217 235 243 35 6 218 165 1 206 154 146 113 85 41 181 244 255 37 206 171 37 118 206 42 240 175 96
100 133 71 199 125 253 115 6 187 101 22 71 60 189 164 36 230 161 225 14 164 254 64 71 230 118 112 218
247 183 211 8 118 21 216 65 83 62 228 247 166 252 115 80 122 247 113 28 101 59 40 123 211 191 6 37 157
210 80 48 13 28 166 64 111 51 255 138 124 208 200 213 119 55 0 168 236 113 117 248 39 169 244 245 22
182 46 188 5 227 219 9 217 221 21 160 207 143 195 85 0 196 34 185 123 219 195 227 128 96 131 205 162
162 170 185 206 118 91 144 15 232 140 227 112 181 174 196 189 183 29 228 243 110 79 199 203 146 77 97
97 111 15 16 106 58 28 153 183 119 203 48 93 165 76 67 220 246 25 215 96 172 83 118 85 6 95 239 162 4
122 245 115 174 243 100 99 193 61 2 4 159 228 210 79 54 16 75 82 148 240 204 138 219 86 161 89 170 169
53 220 204 205 35 42 59 75 69 105 39 210 93 190 161 254 42 138 161 9 195 105 196 239 115 68 153 139 215
209 9 249 225 52 222 169 24 40 192 52 82 242 22 153 6 119 9 4 53 203 184 98 187 80 108 35 207 235 109
54 159 111 195 132 229 7 180 218 149 122 177 124 238 89 114 166 127 0 16 202 32 173 121 204 53 117 166
241 168 187 106 148 78 60 89 252 102 245 223 112 11 248 133 222 154 79 214 159 215 155 135 117 185 28
131 104 70 227 161 167 244 36 95 137 110 239 226 48 139 86 115 92 172 179 233 19 176 215 245 98 38 228
71 139 77 28 111 30 248 73 154 133 73 6 230 191 229 167 25 165 65 240 171 64 224 159 240 241 59 95 93
179 193 145 210 11 56 247 225 135 193 241 107 130 147 215 4 23 95 19 92 122 77 112 249 53 193 149 215
4 111 191 38 184 250 4 248 58 188 141 24 59 225 166 149 45 48 130 149 151 247 184 71 234 125 130 61 242
217 78 225 224 215 105 123 207 167 19 197 218 208 174 22 188 161 93 45 248 207 65 59 82 210 142 28 166
157 88 239 211 15 211 174 248 153 249 52 49 55 244 171 5 111 232 87 11 254 115 208 79 44 233 39 30 166
159 84 239 83 67 191 19 129 55 244 171 5 127 3 244 147 74 250 73 135 233 39 215
251 116 2 250 145 134 126 65 67 191 3 224 111 128 126 114 73 63 249 48 253 148
122 159 26 250 157 8 188 161 95 45 248 27 160 159 82 210 79 57 76 191 246 73
124 58 240 235 206 96 33 54 28 12 26 14 30 0 127 3 28 108 151 28 108 31 230 160
90 239 83 179 5 158 8 188 161 95 45 248 27 160 159 90 210 79 61 76 191 78 189
79 13 253 78 4 222 208 175 22 252 13 208 175 83 210 175 115 152 126 152 61 73
251 216 169 134 127 39 2 111 248 87 11 254 6 248 135 133 237 95 221 133 35 12
60 240 204 75 195 192 19 129 55 12 172 5 127 11 12 172 60 247 114 228 193 23
124 224 201 151 23 184 5 4 20 132 227 94 61 27 91 216 195 22 41 246 71 6 86 99
128 10 156 192 136 92 26 161 47 228 144 37 42 121 2 107 237 93 107 244 69 60
102 146 170 156 192 172 90 99 182 182 151 26 187 111 209 46 155 27 219 159 89
101 85 81 176 66 142 252 245 4 31 120 118 231 136 203 175 57 56 246 177 95 101
112 236 27 121 221 193 177 111 237 111 26 28 251 102 127 176 177 26 187 255 108
187 108 112 140 194 52 139 146 225 138 126 180 164 24 33 138 216 17 213 182 112
228 241 35 124 224 249 163 23 56 79 111 137 14 252 9 232 229 153 217 31 169 175
50 67 246 141 188 238 12 217 183 246 55 205 144 125 179 63 216 99 141 221 127
182 221 237 111 205 21 9 11 29 21 147 255 109 127 122 41 215 142 12 146 3 79 82
29 137 160 25 36 63 102 173 25 36 141 221 159 207 110 229 247 143 162 210 233
144 54 86 43 147 100 187 120 100 148 28 120 42 236 72 12 205 40 249 49 107 205
40 105 236 254 124 118 171 163 164 45 96 149 168 120 119 148 240 69 54 74 152
86 254 9 223 205 151 40 73 86 243 136 125 210 23 214 131 187 240 46 74 30 48
161 223 11 192 142 151 88 86 225 248 54 76 110 98 246 229 29 244 40 41 143 178
242 104 202 142 150 236 195 197 95 233 119 154 44 216 71 184 217 225 122 115
147 108 30 194 251 108 179 88 101 244 107 129 192 94 46 146 220 166 75 208 8 22
81 38 5 97 180 158 175 65 41 13 194 69 182 94 39 241 44 184 187 153 38 243 132
162 242 67 138 10 126 166 209 44 163 75 15 233 95 107 238 237 205 146 30 111
189 165 103 165 195 213 147 172 122 50 45 78 234 61 79 167 159 239 194 155 8
208 215 179 205 58 163 239 243 104 70 19 69 63 104 207 95 139 239 203 184 11
147 121 144 210 79 252 211 111 72 137 179 4 22 130 63 227 224 97 53 159 101 49
61 161 95 146 68 4 89 14 150 171 217 50 88 72 193 124 154 191 199 155 252 125
65 191 117 1 52 103 75 20 124 195 221 190 128 39 61 239 82 31 252 119 160 171
130 38 119 176 128 137 216 81 219 193 247 224 27 233 58 50 220 110 202 184 131
97 25 99 221 52 204 225 100 56 28 94 93 93 97 169 67 136 208 81 36 126 141 74
217 84 73 236 2 174 160 118 137 209 59 239 143 58 61 220 115 96 25 46 72 93 234
63 68 70 125 196 130 164 28 244 49 119 175 139 21 183 123 110 218 195 92 173 75
4 189 219 213 29 119 220 106 9 252 63 21 43 224 173 72 170 18 158 57 50 183 18
152 168 68 145 100 175 144 16 207 187 182 121 57 42 78 73 31 32 53 243 162 213
234 141 39 254 238 234 8 86 47 156 225 164 226 53 100 182 253 148 215 29 21 156
24 187 38 184 73 132 50 55 170 172 22 232 178 65 175 59 122 171 165 59 35 142
14 177 122 213 88 105 232 19 207 212 139 203 162 220 235 90 158 101 163 137 39
138 170 32 18 237 74 196 249 181 214 149 215 18 112 71 80 68 81 97 29 242 238
151 137 103 32 241 61 145 81 223 242 6 166 139 60 221 50 109 223 234 91 250 191
244 139 223 144 32 125 224 25 19 242 158 226 6 53 93 247 45 187 239 188 176 76
157 182 6 89 215 250 144 117 136 192 173 4 180 11 200 150 170 65 81 155 186 102
152 126 17 117 71 5 36 205 118 38 219 212 85 84 119 68 115 93 103 236 219 47 44
15 22 53 90 92 199 166 61 82 192 243 138 59 80 51 93 243 6 133 13 12 162 212 68
171 5 25 125 97 86 112 187 215 237 26 253 161 223 106 113 23 243 206 24 125 50
124 30 30 33 4 19 218 164 47 12 129 225 184 198 14 14 107 118 110 71 233 128
223 227 75 109 88 92 23 112 41 88 184 66 62 117 187 231 174 231 65 104 159 46
75 7 9 40 186 154 15 149 4 192 247 59 169 246 6 35 231 194 44 243 53 128 124
185 70 15 242 229 154 60 53 121 249 198 218 181 193 237 138 101 126 217 149 11
109 88 20 118 239 138 169 185 133 175 219 43 121 201 119 204 230 75 219 162 63
234 130 221 234 242 96 121 201 68 233 169 188 86 186 192 118 52 189 128 220 22
242 250 133 133 170 245 87 51 140 10 39 218 130 9 45 111 248 87 173 214 217 25
162 215 124 203 177 181 33 162 50 238 72 163 103 185 232 217 217 120 104 106
158 137 122 38 200 93 88 158 105 32 127 160 249 240 98 241 241 102 94 0 205 209
64 243 144 237 248 32 103 218 72 119 236 190 229 142 138 26 245 174 65 220 68
134 57 118 60 203 119 220 235 143 249 58 127 59 59 59 27 56 151 200 119 192 188
231 187 19 221 135 149 252 18 254 13 113 251 158 15 29 194 96 108 103 100 129
175 185 128 54 114 38 96 253 218 153 160 75 24 59 20 4 166 160 71 61 242 121
180 84 167 28 179 220 100 53 3 52 18 228 77 70 35 205 189 70 134 99 178 56 114
49 136 195 243 45 127 2 150 53 52 52 207 181 225 240 26 245 44 27 114 121 158
75 24 166 167 187 214 152 38 12 57 125 230 159 62 112 44 221 228 201 113 250
125 211 165 57 115 144 14 129 184 16 159 169 241 141 160 167 217 159 0 8 233 19
207 119 70 166 235 33 205 54 144 174 217 165 125 72 186 107 14 45 208 159 140
193 128 70 253 212 7 31 145 222 227 254 109 53 93 147 102 221 179 12 110 46 23
152 216 112 14 169 179 105 213 76 196 188 97 86 10 129 34 227 0 137 96 112 58
46 13 109 88 20 104 139 63 210 174 203 4 123 166 249 233 113 26 33 43 230 216
132 23 72 61 75 21 235 23 29 140 242 86 162 14 88 182 111 186 80 32 159 181 24
207 88 37 83 31 89 95 209 2 208 125 35 23 130 132 228 18 121 123 65 70 232 62
54 129 219 2 228 240 185 239 187 154 237 141 44 223 135 53 216 174 52 251 26
209 62 134 235 168 199 233 67 215 70 38 136 189 71 86 31 217 166 229 211 61 138
246 141 93 162 12 104 143 67 247 64 128 8 188 160 187 151 63 172 100 115 172
185 190 165 91 99 218 137 96 134 202 67 121 204 11 205 46 251 197 29 59 116 148
65 46 169 239 31 153 1 111 0 125 83 20 84 131 141 209 25 82 69 111 76 235 213
179 134 150 207 220 125 156 82 234 51 45 22 168 3 191 220 81 127 194 97 104 165
205 255 76 76 27 250 236 61 26 58 224 177 87 38 195 208 70 218 57 93 191 28 88
250 128 85 174 199 115 236 77 120 59 130 57 150 37 104 70 15 82 92 36 9 188 117
61 115 120 65 181 243 108 240 116 240 169 12 197 113 13 196 210 192 12 210 174
41 116 89 89 140 137 78 59 26 174 148 37 41 169 146 115 119 91 216 29 42 142 53
221 129 128 161 130 54 189 214 69 116 199 118 45 106 135 215 207 24 181 246 211
235 181 92 211 113 57 252 211 55 161 124 62 86 236 25 218 133 101 160 11 237
202 28 106 22 48 200 128 102 7 194 235 136 90 226 118 129 27 195 201 149 57 234
65 110 206 199 3 199 54 187 72 16 144 40 243 65 79 36 17 137 4 75 34 15 135 221
130 84 167 45 125 101 247 207 112 203 188 123 99 253 164 199 149 219 230 15 112
51 155 107 151 223 72 154 107 9 92 75 224 90 12 155 111 202 240 163 207 255 1
80 75 1 2 23 11 20 0 0 0 8 0 218 62 46 62 215 233 78 110 174 11 0 0 207 84 0 0
7 0 9 0 0 0 0 0 0 0 0 0 0 128 0 0 0 0 115 116 114 46 100 97 116 85 84 5 0 7 37
1 48 77 80 75 5 6 0 0 0 0 1 0 1 0 62 0 0 0 228 11 0 0 0 0
]

    "Created: / 25-01-2011 / 22:49:33 / cg"
!

strDatFromZipArchiveDataFile
^ '{\rtf1\ansi\deflang3081\ftnbj\uc1\deff0
{\fonttbl{\f0 \fswiss Arial;}{\f1 \froman \fcharset2 Times New Roman;}{\f2 \froman \fcharset2 Symbol;}{\f3 \fswiss \fcharset0 Times New Roman;}{\f4 \fswiss \fcharset0 Frutiger 45 Light;}{\f5 \fnil Courier New;}{\f6 \fnil Lucida Sans;}}
{\colortbl ;\red255\green255\blue255 ;\red0\green0\blue0 ;\red0\green64\blue128 ;\red0\green0\blue176 ;\red0\green0\blue210 ;\red0\green0\blue255 ;\red255\green255\blue128 ;\red0\green0\blue160 ;}
{\stylesheet{\fs20\cf2\cb1\chcbpat1 Normal;}{\cs1\f1\fs20\cf2\cb1\chcbpat1 Default Paragraph Font;}{\s2\snext0\f1\fs28\b\cf2\cb1\chcbpat1 TOC 1;}{\s3\snext0\f1\fs24\b\cf2\cb1\chcbpat1\fi0\li180\ri0 TOC 2;}{\s4\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li360\ri0 TOC 3;}{\s5\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li540\ri0 TOC 4;}{\s6\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li720\ri0 TOC 5
;}{\s7\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li900\ri0 TOC 6;}{\s8\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li1080\ri0 TOC 7;}{\s9\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li1260\ri0 TOC 8;}{\s10\snext0\f1\fs24\cf2\cb1\chcbpat1\fi0\li1440\ri0 TOC 9;}{\s11\snext0\outlinelevel0\f0\fs32\b\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel0 Heading 1;}{\s12\snext0\outlinelevel1\f0\fs30\b\cf4\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel1 Heading 2
;}{\s13\snext0\outlinelevel2\f0\fs28\b\cf5\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel2 Heading 3;}{\s14\snext0\outlinelevel3\f0\fs24\b\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel3 Heading 4;}{\s15\snext0\outlinelevel4\f0\fs24\b\i\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel4 Heading 5;}{\s16\snext0\outlinelevel5\f0\fs22\b\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel5 Heading 6
;}{\s17\snext0\outlinelevel6\f0\fs22\ul\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel6 Heading 7;}{\s18\snext0\outlinelevel7\f0\fs20\ul\i\cf2\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel7 Heading 8;}{\s19\snext0\outlinelevel8\f0\fs22\cf3\cb1\chcbpat1\sb240\sa60\sl0\outlinelevel8 Heading 9;}{\s20\snext0\f0\fs32\b\cf2\cb1\chcbpat1\sb240\sa60\sl0\qc Title
;}{\s21\snext0\f1\fs20\cf2\cb1\chcbpat1\fi-360\li360\ri0 Numbered List;}{\s22\snext0\f1\fs20\cf2\cb1\chcbpat1\fi-360\li360\ri0 Bulleted List;}{\s23\snext0\f1\fs20\cf2\cb1\chcbpat1\sb0\sa120\sl0 Body Text;}{\s24\snext0\f1\fs18\cf2\cb1\chcbpat1\sb0\sa120\sl0\sl480\slmult1 Body Text 2;}{\s25\snext0\f1\fs16\cf2\cb1\chcbpat1\sb0\sa120\sl0 Body Text 3
;}{\s26\snext0\f1\fs20\cf2\cb1\chcbpat1 Note Heading;}{\s27\snext0\f5\fs20\cf2\cb1\chcbpat1 Plain Text;}{\s28\snext0\f1\fs20\b\cf2\cb1\chcbpat1 Strong;}{\s29\snext0\f1\fs20\i\cf2\cb1\chcbpat1 Emphasis;}{\s30\snext0\f1\fs20\ul\cf6\cb1\chcbpat1 Hyperlink;}{\s31\snext0\f1\fs20\cf2\cb1\chcbpat1 Footer;}{\s32\snext0\f1\fs20\cf2\cb1\chcbpat1 Header
;}{\s33\snext0\f5\fs18\cf2\cb1\chcbpat1 Code;}{\cs34\f1\fs20\i\cf3\cb1\chcbpat1 Field Label;}{\cs35\f1\fs22\b\cf2\cb1\chcbpat1 Table Heading;}{\cs36\f6\fs16\b\protect\cf2\cb7\chcbpat7 SSBookmark;}{\cs37\f1\fs20\b\ul\cf2\cb1\chcbpat1 Object type;}{\s38\snext0\f1\fs20\b\i\cf8\cb1\chcbpat1 List Header;}}
{\*\revtbl{Unknown;}}
{\*\listtable
{\list\listtemplateid1
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''00.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List1;}\listid1
}
{\list\listtemplateid2
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List2;}\listid2
}
{\list\listtemplateid3
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f1\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List3;}\listid3
}
{\list\listtemplateid4
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f1\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List4;}\listid4
}
{\list\listtemplateid5
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List5;}\listid5
}
{\list\listtemplateid6
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List6;}\listid6
}
{\list\listtemplateid7
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''00.}{\levelnumbers \''01}\f3\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List7;}\listid7
}
{\list\listtemplateid8
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List8;}\listid8
}
{\list\listtemplateid9
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List9;}\listid9
}
{\list\listtemplateid10
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List10;}\listid10
}
{\list\listtemplateid11
{\listlevel\levelnfc23\levelfollow0\levelstartat1{\leveltext \''01\''b7}{\levelnumbers}\f2\fs24}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''01.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''02.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''03.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''04.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''05.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''06.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''07.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''08.}{\levelnumbers \''01}}
{\listname List11;}\listid11
}
{\list\listtemplateid12
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''01\''00}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''03\''00.\''01}{\levelnumbers \''01\''03}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''05\''00.\''01.\''02}{\levelnumbers \''01\''03\''05}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''07\''00.\''01.\''02.\''03}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listname ;}\listid858661625
}
{\list\listtemplateid13
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''01\''00}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''03\''00.\''01}{\levelnumbers \''01\''03}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''05\''00.\''01.\''02}{\levelnumbers \''01\''03\''05}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''07\''00.\''01.\''02.\''03}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listname MasterList;}\listid863938703
}
{\list\listtemplateid14
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''00.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''03\''00.\''01}{\levelnumbers \''01\''03}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''05\''00.\''01.\''02}{\levelnumbers \''01\''03\''05}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''07\''00.\''01.\''02.\''03}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listname List864109812_1;}\listid864109812
}
{\list\listtemplateid15
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''00.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''03\''00.\''01}{\levelnumbers \''01\''03}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''05\''00.\''01.\''02}{\levelnumbers \''01\''03\''05}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''07\''00.\''01.\''02.\''03}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listname List1036992718_1;}\listid1036992718
}
{\list\listtemplateid16
{\listlevel\levelnfc0\levelfollow0\levelstartat1{\leveltext \''02\''00.}{\levelnumbers \''01}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''03\''00.\''01}{\levelnumbers \''01\''03}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''05\''00.\''01.\''02}{\levelnumbers \''01\''03\''05}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''07\''00.\''01.\''02.\''03}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listlevel\levelnfc0\levelfollow0\levelstartat0{\leveltext \''08\''00.\''01.\''02.\''03.}{\levelnumbers \''01\''03\''05\''07}}
{\listname List1037018281_1;}\listid1037018281
}
}
{\*\listoverridetable}
\paperw12240\paperh15840\margl1440\margr1440\margt1440\margb1440\headery720\footery720\nogrowautofit\deftab720\formshade\fet4\aendnotes\aftnnrlc\pgbrdrhead\pgbrdrfoot
\sectd\pgwsxn12240\pghsxn15840\marglsxn1440\margrsxn1440\margtsxn1440\margbsxn1440\headery720\footery720\sbkpage\pgncont\pgndec
\plain\plain\f0\fs24\pard\s0\sl260\ltrpar\ql\widctlpar\lang2055\hich\f4\dbch\f4\loch\f4\fs21\ltrch \{1:F01UBSWCHZHC80A5910123987\}\{2:O5641519110111CEDELULLLXXX14922096491101111519N\}\{3:\{108:2DBGFM9B1BO\}\}\{4:\par
\lang1046\hich\f4\dbch\f4\loch\f4\ltrch :16R:GENL\par
:20C::CORP//0000000081612332\par
:20C::SEME//000000001282645S\par
:23G:NEWM\par
:22F::CAEV//BPUT\par
:22F::CAMV//VOLU\par
\lang2057\hich\f4\dbch\f4\loch\f4\ltrch :98C::PREP//20110111151858\par
:25D::PROC//COMU\par
:16S:GENL\par
:16R:USECU\par
:35B:ISIN US338032AX31\par
/XS/019063364\par
USD 3,25 FISHER SCIENTIFIC(CV) 04-2\par
024\par
:16R:ACCTINFO\par
\lang1046\hich\f4\dbch\f4\loch\f4\ltrch :97A::SAFE//GENR\par
:16S:ACCTINFO\par
:16S:USECU\par
:16R:CADETL\par
:98A::ANOU//20110111\par
:16S:CADETL\par
:16R:CAOPTN\par
\lang2057\hich\f4\dbch\f4\loch\f4\ltrch :13A::CAON//001\par
:22F::CAOP//CASH\par
:11A::OPTN//USD\par
\lang1046\hich\f4\dbch\f4\loch\f4\ltrch :17B::DFLT//N\par
:98C::MKDT//20110222120000\par
\lang2057\hich\f4\dbch\f4\loch\f4\ltrch :98C::RDDT//20110222100000\par
:69A::PWAL//20110201/20110222\par
:92K::GRSS//UKWN\par
:92A::RATE//100,\par
:16R:CASHMOVE\par
:22H::CRDB//CRED\par
:98A::PAYD//20110301\par
:98A::VALU//20110301\par
:98A::EARL//20110301\par
:16S:CASHMOVE\par
:16S:CAOPTN\par
:16R:CAOPTN\par
:13A::CAON//002\par
\lang1034\hich\f4\dbch\f4\loch\f4\ltrch :22F::CAOP//NOAC\par
:17B::DFLT//Y\par
\lang2057\hich\f4\dbch\f4\loch\f4\ltrch :16S:CAOPTN\par
:16R:ADDINFO\par
:70E::ADTX//++ ADDITIONAL INFORMATION\par
++PLEASE BE ADVISED THAT THIS\par
EVENT HAS NOT BEEN CONFIRMED\par
BY THE DEPOSITORY.\par
.\par
+++HOW TO INSTRUCT+++\par
1) PLEASE STATE THE NOMINAL\par
AMOUNT YOU WISH TO PRESENT TO\par
THE PUT\par
.\par
:70E::ADTX//THIS SUMMARY DOES NOT\par
CONSTITUTE A LEGALLY BINDING\par
DESCRIPTION OF THE CHOICES\par
OFFERED TO CLEARSTREAM\par
BANKING CUSTOMERS AND CANNOT\par
BE RELIED UPON AS SUCH. CB\par
CUSTOMERS ARE CONSIDERED TO\par
UNDERSTAND THE OFFER AND TO\par
INSTRUCT CB ACCORDINGLY.\par
CUSTOMERS MAY WISH TO SEEK\par
:70E::ADTX//INDEPENDENT LEGAL ADVICE ON\par
THE INTERPRETATION OF THE\par
OFFER. THIS NOTIFICATION CAN\par
NOT BE REPROCUCED OR\par
TRANSMITTED IN ANY FORM OR BY\par
ANY MEANS, IF NEITHER YOU NOR\par
THE ADRESSEE IS ENTITLED TO\par
PARTICIPATE IN THE RELEVANT\par
CORPORATE ACTION. YOU SHALL\par
BEAR SOLE RESPONSIBILITY FOR\par
:70E::ADTX//ANY AND ALL HARMFUL\par
CONSEQUENCES, LOSSES OR\par
DAMAGES, WHICH MAY BE\par
SUFFERED FOR ANY REASON BY\par
YOURSELVES, THE ADDRESSEE,\par
THIRD PARTIES OR CB BY\par
REPRODUCING OR TRANSMITTING\par
THE NOTIFICATION.\par
:70E::PACO//ATTENTION: SECURITIES\par
ADM/CORPORATE ACTIONS/REORG\par
\lang2055\hich\f4\dbch\f4\loch\f4\ltrch :70E::PACO//DAVID VAXELAIRE DOMESTIC CORP\par
ACT LUXEMBOURGPHONE: 00 352\par
243 32143\par
:16S:ADDINFO\par
\pard\s0\ql\plain\f0\fs24\lang2055\hich\f4\dbch\f4\loch\f4\fs21\ltrch -\}\plain\lang3081\hich\f0\dbch\f0\loch\f0\fs20\par
}
'

    "Created: / 25-01-2011 / 22:55:46 / cg"
!

test01_notWorking
    |archive fileContents|

    archive := ZipArchive readingFrom:(self badZipArchiveDataFile readStream).
    fileContents := archive extract:'str.dat'.
    self assert:(fileContents asString = (self strDatFromZipArchiveDataFile copyReplaceString:Character cr asString withString:String crlf))

    "Created: / 25-01-2011 / 22:49:10 / cg"
! !

!ZipArchiveTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

