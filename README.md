# Optical_Flow_HAR
A Hybrid Speed and Radial Distance Feature Descriptor using Optical Flow Approach in HAR
## dataset 
weizmann dataset: https://www.wisdom.weizmann.ac.il/~vision/SpaceTimeActions.html
### dataset structure: 
Weizmann 
- Train_datasets
  - walk
  - bend
  - jump
  - ...
- Test_datasets
  - walk
  - bend
  - jump
  - ...
###  The resuslt are updated by extract 72*2(speed)+24(Distance) on Weizmann datasets.
RESULT TABLE (UPDATED)03/08/2022:
### Average accuracy : __94.7%__
<table width="255" border="0" cellpadding="0" cellspacing="0" style="width:191.25pt;border-collapse:collapse;table-layout:fixed;">
   <colgroup><col width="72" span="2" style="width:54.00pt;">
   <col width="111" style="mso-width-source:userset;mso-width-alt:3552;">
   </colgroup><tbody><tr height="46" style="height:34.50pt;">
    <td class="xl65" height="46" width="72" style="height:34.50pt;width:54.00pt;" x:str="">Method</td>
    <td class="xl65" width="72" style="width:54.00pt;" x:str="">Human action</td>
    <td class="xl65" width="111" style="width:83.25pt;" x:str="">classification</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl66" height="184" rowspan="8" style="height:138.00pt;border-right:.5pt solid windowtext;border-bottom:.5pt solid windowtext;" x:str="">Proposed Method</td>
    <td class="xl65" x:str="">WALK</td>
    <td class="xl67" x:num="1.">100%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">BEND</td>
    <td class="xl68" x:num="0.86900000000000011">86.90%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">JACK</td>
    <td class="xl67" x:num="0.95999999999999996">96%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">PJUMP</td>
    <td class="xl67" x:num="1.">100%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">RUN</td>
    <td class="xl67" x:num="0.91000000000000003">91%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">SIDE</td>
    <td class="xl67" x:num="1.">100%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">WAVE1</td>
    <td class="xl67" x:num="0.92000000000000004">92%</td>
   </tr>
   <tr height="23" style="height:17.25pt;">
    <td class="xl65" x:str="">WAVE2</td>
    <td class="xl67" x:num="0.92000000000000004">92%</td>
   </tr>
  </tbody></table>





https://user-images.githubusercontent.com/64634997/182770073-75d8c344-acf2-4821-b3e7-40ee91290316.mp4


