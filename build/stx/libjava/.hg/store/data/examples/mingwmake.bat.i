         �        ��������b|aaT����!�!�?$             x�U�QK�0��k~�y�EL�ڵk��Æ(�s�ܔh��4u�w� x����;�.�
ݸEՒ.�u-�Kg}sv��I�	����Q�}�ɫ:�6ź�WY]��*K�hU�1�6�-���� >ϼ��0�W3&=?@�ٖ⌤�#�e�Az���I1:���6�C)8���m;�!OQ&�018���I*��Xo����9�������{���Onnc?�Yk     �     �  �          ����/�OWY������cN/��            x�MO�j�@���wh;iC�O ��RT�)��^��,Fi߰�Կ=k]v�e��B~c7�M����/��Xa��G�<H�Ǻ�h��쫱WBߣ�X��P����4�����^S�'I�0����I���b�\M���[��������(ϲ�gԏ���gH�����_�����y1P���������ُZ��Ge�C�L��b�ӥ���pR8G��k��"H�4�󈃯��73Ȃ� (7R�    �        �     	1���������*�zB�$��02��H���                �        �     	L      ���x{���5�<�DR�qz                �     l  �     	�   ����w�l�M�����w̺�ۙ��              h  �   `@pushd ..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %USEMINGW_ARG% %*
    A     m  y     
�   ����B{�`d
�Ҏ����Eti            x�c``<� ��R�3���%.�Z��̜�Ҽt��
��̤�ĲD�Ԋ�܂��b������3.�NNQ��KN��Q���K/�M�NUP5TP5������30r  R0�    �        y     
�   ���������8����#��밙�^�                �        y     
�      �tR��w_O���-N���x��                �     Q  �        ����_>�џ4m~�� P���R,�              N  w   E@pushd tomcat6
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd
    �     :  �     _   �����7�n��;f�J�˓#����              �  "   .@echo "Buildung stx/libjava/examples/tomcat6"
