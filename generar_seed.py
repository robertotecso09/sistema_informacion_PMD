# Genera data/seed.json (líneas + usuarios con contraseña cifrada) y ../credenciales.csv desde el Formato A.
import pandas as pd, json, secrets, hashlib, csv, sys
X = sys.argv[1]
df = pd.read_excel(X, sheet_name='Concentrado Formato A', dtype=str).dropna(subset=['No. Linea de Acción'])
H, I = 'Dirección(es) asociada(s) por autoasignación', 'Area Responsable'
U = {  # id: (nombre, [textos H], [códigos I])
 'sa':('Secretaría del Ayuntamiento',['Secretaría del Ayuntamiento'],['SA']),
 'decur':('Dirección de Educación, Cultura y Recreación (DECUR)',['Dirección de Educación, Cultura y Recreación (DECUR)'],['DECUR']),
 'dif':('DIF Municipal',['DIF Municipal','DIF Municipal; SIPINNA'],['DIF']),
 'transito':('Dirección de Tránsito y Vialidad Municipal',['Dirección de Tránsito y Vialidad Municipal'],['DTyVM','SEG.PUB']),
 'dop':('Dirección de Obras Públicas',['Dirección de Obras Públicas','Dirección de Obras Públicas (DOP)'],['DOP']),
 'dpa':('Dirección de Protección Ambiental',['Dirección de Protección Ambiental'],['DPA']),
 'dam':('Dirección de Atención a las Mujeres',['Dirección de Atención a las Mujeres'],['DAM']),
 'dp':('Dirección de Programación',['Dirección de Programación'],['DP','PROGRAMACION']),
 'ddr':('Dirección de Desarrollo Rural',['Dirección de Desarrollo Rural'],['DDR']),
 'dpc':('Dirección de Protección Civil',['Dirección de Protección Civil'],['DPC']),
 'dadmon':('Dirección de Administración',['Dirección de Administración'],['Dadmon','REC.HUMAN']),
 'dfeyt':('Dirección de Fomento Económico y Turismo',['Dirección de Fomento Económico y Turismo'],['DFEyT']),
 'dacm':('Dirección de Atención Ciudadana Municipal',['Dirección de Atención Ciudadana Municipal'],['DACM']),
 'cm':('Contraloría Municipal',['Contraloría Municipal'],['CM']),
 'sipinna':('SIPINNA',['Sistema Nacional de Protección integral de niños, niñas y adolescentes (SIPINNA)'],['SIPINNA']),
 'daj':('Dirección de Asuntos Jurídicos',['Dirección de Asuntos Jurídicos'],['DAJ']),
 'cga':('Coordinación General de Archivo',['Coordinación General de Archivo'],['CGA']),
 'comsoc':('Comunicación Social',[],['ComSoc']),
 'sinasignar':('SIN ASIGNAR (reasignar desde el panel admin)',[],[]),
}
byH = {t:k for k,v in U.items() for t in v[1]}
byI = {c.lower():k for k,v in U.items() for c in v[2]}
def quien(r):
    h = r[H]
    if isinstance(h,str) and h.strip() in byH: return byH[h.strip()]
    i = r[I]
    if isinstance(i,str):
        c = i.replace(';','/').replace(',','/').split('/')[0].strip().lower()
        if c in byI: return byI[c]
    return 'sinasignar'
def hp(pw):
    salt = secrets.token_hex(8)
    return f"{salt}${hashlib.scrypt(pw.encode(), salt=salt.encode(), n=16384, r=8, p=1, dklen=64).hex()}"
L = []
for _, r in df.iterrows():
    g = lambda c: (r[c].strip() if isinstance(r[c], str) else '')
    L.append(dict(id=g('No. Linea de Acción'), eje=f"{g('Eje')} – {g('Nombre del eje')}", obj=g('No. Objetivo'),
                  est=g('No. Estrategia'), texto=g('Línea de acción'), unidad=g('UNIDAD DE MEDIDA'), area=quien(r)))
usados = {l['area'] for l in L}
al = 'abcdefghjkmnpqrstuvwxyz23456789'
users, cred = {}, [('usuario','contraseña','area','lineas')]
for k,v in U.items():
    if k not in usados: continue
    pw = ''.join(secrets.choice(al) for _ in range(8)) if k!='sinasignar' else ''
    users[k] = dict(nombre=v[0], hash=hp(pw) if pw else '')
    if pw: cred.append((k, pw, v[0], sum(l['area']==k for l in L)))
json.dump(dict(lineas=L, usuarios=users), open('data/seed.json','w'), ensure_ascii=False)
csv.writer(open('../credenciales.csv','w',newline='',encoding='utf-8-sig')).writerows(cred)
print(len(L),'líneas;',len(users),'usuarios;', sum(l['area']=='sinasignar' for l in L),'sin asignar')
