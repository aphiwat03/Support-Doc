---
slug: dc-network-boot-san-blade
title: เครือข่าย OOB, กระบวนการ PXE Boot, ระบบ SAN Zoning และ Blade Server
summary: การแยกวงแลน Out-of-Band (OOB), ขั้นตอนการบูตผ่านเครือข่าย PXE (DHCP + TFTP), พื้นฐาน SAN Fibre Channel & Zoning, Blade Server (Cisco UCS / HPE) และ Hypervisor
read_time_minutes: 10
difficulty: intermediate
display_order: 3
---

# เครือข่าย OOB, กระบวนการ PXE Boot, ระบบ SAN Zoning และ Blade Server

นอกจากการประกอบฮาร์ดแวร์แล้ว วิศวกรปฏิบัติการ Data Center ต้องเข้าใจว่าเซิร์ฟเวอร์เครื่องเปล่าที่เพิ่งแกะกล่องเข้าตู้แร็ค เชื่อมต่อกับเครือข่ายจัดการระยะไกล โหลดระบบปฏิบัติการอัตโนมัติ และมองเห็นพื้นที่จัดเก็บข้อมูลส่วนกลาง (SAN Storage) ได้อย่างไร

---

## 1. เครือข่าย Out-of-Band (OOB Management Network)

ในสถาปัตยกรรม Data Center มาตรฐาน เครือข่ายจะถูกแยกออกเป็น 2 วงที่แยกจากกันอย่างเด็ดขาด:

![แผนผังการแยกวงเครือข่าย Production (In-Band) และ Out-of-Band (OOB Management)](/images/datacenter/oob-management-topology.png)

1. **In-Band (Production Network)**:
   - พอร์ตไฟเบอร์ความเร็วสูง (10G / 25G / 100G) บนการ์ด NIC ที่เชื่อมต่อเข้ากับ Top-of-Rack Switch สำหรับรับส่งทราฟฟิกของแอปพลิเคชันและผู้ใช้งานจริง
2. **Out-of-Band (OOB Management Network)**:
   - พอร์ตสายแลนทองแดง RJ45 ความเร็ว 1Gbps ที่เขียนว่า `iDRAC`, `iLO`, หรือ `IPMI Mgmt` หลังเครื่องเซิร์ฟเวอร์ รวมกับพอร์ต Console ของ Switch/Router
   - เชื่อมต่อเข้ากับ **Management Switch แยกต่างหาก** และเข้าถึงได้เฉพาะวิศวกรที่ต่อ **VPN / Bastion Jump Host** เท่านั้น
   - **ทำไมต้องแยกวง OOB?** เพราะหากวันใดเกิดเหตุการณ์ตั้งค่า Firewall ผิดพลาดบน OS หรือ Production Switch ล่มจน SSH เข้าเซิร์ฟเวอร์ไม่ได้ วิศวกรยังสามารถเข้าทางวง OOB เพื่อเปิดหน้าจอ Console เข้าไปแก้ไขและกู้คืนระบบได้เสมอ

### การตั้งค่าและตรวจเช็ก OOB เบื้องต้น
- ตั้งค่า IP ของ BMC (iDRAC/iLO) ได้ 2 วิธี: ตั้งผ่านหน้าจอ **BIOS Setup (F2 / F9)** ตอนบูตเครื่อง หรือตั้งค่าให้รับ IP จาก **DHCP (พร้อมผูก MAC Reservation)**
- หากปิง IP ของ iDRAC/iLO ไม่เจอ ให้ตรวจ:
  1. โหมดพอร์ตใน BIOS ตั้งเป็น **Dedicated NIC** (ใช้พอร์ตแยกเฉพาะ) หรือ **Shared LOM** (แชร์พอร์ตเดียวกับการ์ดแลนหลัก)
  2. ไฟสถานะ Link/Act ที่พอร์ต RJ45 หลังเครื่องติดหรือไม่
  3. ค่า Subnet Mask, Default Gateway และ VLAN บนพอร์ต Management Switch ตรงกับวง OOB หรือไม่

---

## 2. กระบวนการบูตของระบบ และ PXE Boot (Preboot Execution Environment)

ในบริษัท Hosting หรือ Cloud ที่มีเซิร์ฟเวอร์หลายพันเครื่อง เราจะไม่เดินถือแฟลชไดรฟ์ไปเสียบลง Linux/Windows ทีละเครื่อง แต่จะใช้การบูตติดตั้งผ่านสายแลนที่เรียกว่า **PXE Boot (อ่านว่า "พิกซี่บูต")**

![ลำดับการทำงานของ PXE Boot ผ่าน DHCP และ TFTP Server](/images/datacenter/pxe-boot-sequence.png)

### ลำดับขั้นตอนการบูตของเครื่องเซิร์ฟเวอร์ตั้งแต่กดปุ่ม Power
1. **Power-On & BMC Initialization**: จ่ายไฟเข้าเมนบอร์ด ชิป BMC ตื่นขึ้นมาตรวจเซนเซอร์ไฟและพัดลม
2. **POST (Power-On Self-Test)**: BIOS/UEFI ตรวจสอบ CPU, นับจำนวน RAM (DIMM), และสแกนหาการ์ด PCIe / HBA / RAID
3. **Boot Device Selection**: BIOS/UEFI มองหาอุปกรณ์บูตตามลำดับที่ตั้งไว้ (เช่น Disk ในเครื่อง หรือ Network PXE)
4. **ขั้นตอน PXE Boot (กรณีบูตผ่านเครือข่ายเพื่อลง OS ใหม่)**:
   - **ขั้นที่ 4.1 (DHCP Discover / Offer)**: การ์ดแลนส่งแพ็กเก็ต广播 (Broadcast) ขอ IP Address จาก DHCP Server
   - **ขั้นที่ 4.2 (DHCP Options 66 & 67)**: DHCP Server ตอบกลับพร้อมมอบ IP Address และแจ้งข้อมูลสำคัญ 2 ค่า คือ **Option 66 (Next-Server / IP ของ TFTP Server)** และ **Option 67 (Boot Filename เช่น `pxelinux.0` หรือ `grubx64.efi`)**
   - **ขั้นที่ 4.3 (TFTP Download)**: การ์ดแลนเชื่อมต่อไปยัง **TFTP Server** (ใช้พอร์ต `UDP 69`) เพื่อดาวน์โหลดไฟล์ Bootloader, Linux Kernel (`vmlinuz`), และ `initrd` ลงมาไว้ใน RAM
   - **ขั้นที่ 4.4 (Automated Installer)**: บูตเข้าสู่ตัวติดตั้งอัตโนมัติ (เช่น Kickstart สำหรับ RHEL/CentOS, Preseed/Cloud-init สำหรับ Ubuntu, หรือ WDS สำหรับ Windows) ดึงไฟล์ระบบปฏิบัติการผ่าน HTTP/NFS จนติดตั้งเสร็จสมบูรณ์
5. **OS Bootloader & Init**: เมื่อมี OS ในดิสก์แล้ว ครั้งต่อไปเครื่องจะบูตเข้า **GRUB2** → โหลด **Linux Kernel** → สตาร์ทโปรเซสหมายเลข 1 คือ **`systemd` (PID 1)** เพื่อเปิดบริการต่างๆ จนขึ้นหน้า Login

---

## 3. พื้นฐานระบบ SAN (Storage Area Network) และการทำ Zoning

ในระบบองค์กรขนาดใหญ่ พื้นที่เก็บข้อมูลสำคัญจะไม่วางไว้แค่ในฮาร์ดดิสก์หน้าเครื่องเซิร์ฟเวอร์ (DAS - Direct Attached Storage) แต่จะเชื่อมต่อผ่านเครือข่ายความเร็วสูงเฉพาะทางที่เรียกว่า **SAN (Storage Area Network)**

![สถาปัตยกรรม Fibre Channel SAN (Fabric A/B) และการทำ WWN Zoning](/images/datacenter/san-fabric-zoning.png)

### คำศัพท์สำคัญของระบบ Fibre Channel SAN ที่ต้องรู้
- **Initiator (ฝั่งผู้ขอใช้ดิสก์)**: คือการ์ด **HBA (Host Bus Adapter)** ที่เสียบอยู่ในเครื่องเซิร์ฟเวอร์
- **Target (ฝั่งผู้ให้บริการดิสก์)**: คือพอร์ตของตู้ **Storage Array** (เช่น NetApp, Dell EMC PowerStore, Pure Storage, Hitachi)
- **WWNN / WWPN (World Wide Node/Port Name)**:
  - เปรียบเสมือน **MAC Address ของโลก Fibre Channel** เป็นตัวเลขฐานสิบหกขนาด 64-bit (เช่น `50:06:0b:00:00:c2:62:01`) ที่ระบุตัวตนของพอร์ต HBA และพอร์ต Storage
- **LUN (Logical Unit Number)**:
  - ก้อนพื้นที่ดิสก์เสมือนที่แบ่งมาจากตู้ Storage Array แล้วส่งมาให้เซิร์ฟเวอร์มองเห็นเหมือนเป็นฮาร์ดดิสก์ลูกหนึ่ง (เช่น `/dev/sdb`)
- **SAN Zoning (การแบ่งโซนบน SAN Switch)**:
  - ทำบน Fibre Channel Switch (เช่น Brocade หรือ Cisco MDS) เพื่อกำหนดสิทธิ์ว่า **พอร์ต HBA ของเซิร์ฟเวอร์เครื่องไหน (Initiator WWPN) มีสิทธิ์มองเห็นพอร์ตของตู้ Storage ตัวไหน (Target WWPN)**
  - กฎมาตรฐานคือ **Single-Initiator Zoning** (1 โซน มีเซิร์ฟเวอร์ 1 พอร์ต จับคู่กับ Storage) เพื่อป้องกันไม่ให้เซิร์ฟเวอร์อื่นมองเห็นหรือเผลอเขียนข้อมูลทับ LUN ของกันและกัน
- **Multipathing (Fabric A & Fabric B)**:
  - เซิร์ฟเวอร์แต่ละเครื่องจะมีพอร์ต HBA 2 พอร์ต แยกต่อเข้า **SAN Switch A** และ **SAN Switch B** หากสวิตช์ตัวใดตัวหนึ่งดับ เซิร์ฟเวอร์ยังอ่านเขียนข้อมูลผ่านอีกเส้นทางได้ต่อเนื่องโดยไม่ล่ม (`multipathd`)

---

## 4. ระบบเบลดเซิร์ฟเวอร์ (Blade Server: Cisco UCS & HPE BladeSystem)

นอกจากเซิร์ฟเวอร์แบบกล่อง 1U/2U (Rack Server) แล้ว ใน Data Center ยังมีเซิร์ฟเวอร์แบบ **Blade Server** ที่นำแผ่นเซิร์ฟเวอร์หลายๆ ใบเสียบรวมกันในโครงตู้เดียว (**Blade Chassis** ขนาด 6U หรือ 10U):

![โครงสร้างตู้ Blade Server Chassis (Cisco UCS / HPE ProLiant Blade)](/images/datacenter/cisco-ucs-hp-blade.png)

- **ข้อดีของ Blade Server**: ใช้ภาคจ่ายไฟ (PSU), พัดลมระบายความร้อน, และโมดูลสวิตช์ด้านหลังร่วมกันทั้งตู้ ช่วยลดจำนวนสายไฟและสายแลนที่ต้องเดินหลังตู้ลงได้มหาศาล
- **Cisco UCS (Unified Computing System)**:
  - มีจุดเด่นคือ **Fabric Interconnect (FI)** และระบบ **Service Profile** ซึ่งเก็บค่าตัวตนของเซิร์ฟเวอร์ (MAC Address, WWPN, การตั้งค่า BIOS, ลำดับการบูต) ไว้เป็นโปรไฟล์ซอฟต์แวร์ หากใบ Blade ใบไหนเมนบอร์ดพัง ช่างสามารถเสียบใบ Blade เปล่าใบใหม่เข้าไป แล้วโยน Service Profile เดิมใส่ เครื่องจะกลับมาทำงานพร้อม MAC และ WWPN เดิมทันทีภายในไม่กี่นาที
- **HPE ProLiant c-Class / HPE Synergy**:
  - ใช้โมดูลจัดการกลางที่เรียกว่า **Onboard Administrator (OA)** หรือ **HPE OneView** ในการควบคุมไฟ พัดลม และ Virtual Connect ทั้ง Chassis

---

## 5. ความรู้พื้นฐานเรื่อง Hypervisor และ Container สำหรับช่าง Data Center

แม้ช่าง Data Center จะดูแลฮาร์ดแวร์เป็นหลัก แต่ในชีวิตจริงเครื่องเซิร์ฟเวอร์เกือบทุกเครื่องทำหน้าที่เป็นโฮสต์รันระบบจำลองเสมือน:

| เทคโนโลยี | ตัวอย่างซอฟต์แวร์ | บทบาทที่เกี่ยวข้องกับงาน Data Center Operations |
|---|---|---|
| **Type-1 Hypervisor (Bare-Metal)** | **VMware ESXi**, **KVM (Proxmox / OpenStack)**, **Citrix XenServer**, **Microsoft Hyper-V** | ติดตั้งลงบนฮาร์ดแวร์เซิร์ฟเวอร์โดยตรงเพื่อแบ่งทรัพยากรเป็นหลาย **VM (Virtual Machine)** ก่อนที่ช่าง DC จะปิดเครื่องโฮสต์เพื่อเปลี่ยนแรมหรือเมนบอร์ด ต้องประสานให้ทีมระบบสั่งเข้า **Maintenance Mode** เพื่อย้าย VM หนีไปยังโฮสต์อื่นก่อนเสมอ (เช่น **VMware vMotion** หรือ **Live Migration**) |
| **Containers** | **Docker**, **containerd**, **Kubernetes (K8s) Worker Nodes** | รันแอปพลิเคชันแบบแยกส่วนโดยแชร์ Linux Kernel เดียวกัน หากโฮสต์ที่เป็น K8s Node ต้องซ่อมฮาร์ดแวร์ ทีมระบบจะสั่ง `kubectl drain <node>` เพื่อย้าย Pod ออกจากเครื่องก่อนให้ช่าง DC ปิดเครื่อง |
