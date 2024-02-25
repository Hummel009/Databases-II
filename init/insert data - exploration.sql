INSERT INTO `rooms` (`r_id`, `r_name`, `r_space`)
VALUES
(1, '������� � ����� ������������', 5),
(2, '������� � ����� ������������', 5),
(3, '������ ������� 1', 2),
(4, '������ ������� 2', 2),
(5, '������ ������� 3', 2);


INSERT INTO `computers` (`c_id`, `c_room`, `c_name`)
VALUES
(1, 1, '��������� A � ������� 1'),
(2, 1, '��������� B � ������� 1'),
(3, 2, '��������� A � ������� 2'),
(4, 2, '��������� B � ������� 2'),
(5, 2, '��������� C � ������� 2'),
(6, NULL, '��������� ��������� A'),
(7, NULL, '��������� ��������� B'),
(8, NULL, '��������� ��������� C');


INSERT INTO `library_in_json`
(
    `lij_id`,
    `lij_book`,
    `lij_author`,
    `lij_genre`
) VALUES
(1, '������� ������', '[{"id":7,"name":"�.�. ������"}]', '[{"id":1,"name":"������"},{"id":5,"name":"��������"}]'),
(2, '��������� ����������������', '[{"id":1,"name":"�. ����"}]', '[{"id":2,"name":"����������������"},{"id":5,"name":"��������"}]'),
(3, '���� ������������� ������', '[{"id":4,"name":"�.�. ������"},{"id":5,"name":"�.�. ������"}]', '[{"id":5,"name":"��������"}]'),
(4, '��������� � �������', '[{"id":2,"name":"�. ������"}]', '[{"id":6,"name":"����������"}]'),
(5, '���������� ����������������', '[{"id":3,"name":"�. �������"},{"id":6,"name":"�. ����������"}]', '[{"id":2,"name":"����������������"},{"id":3,"name":"����������"}]'),
(6, '������ � ������ � �����', '[{"id":7,"name":"�.�. ������"}]', '[{"id":1,"name":"������"},{"id":5,"name":"��������"}]'),
(7, '���� ���������������� �++', '[{"id":6,"name":"�. ����������"}]', '[{"id":2,"name":"����������������"}]');



INSERT INTO `site_pages` (`sp_id`, `sp_parent`, `sp_name`) VALUES
(1, NULL, '�������'),
(2, 1, '���������'),
(3, 1, '���������'),
(4, 1, '��������������'),
(5, 2, '�������'),
(6, 2, '����������'),
(7, 3, '�����������'),
(8, 3, '������� ������'),
(9, 4, '�����'),
(10, 1, '��������'),
(11, 3, '���������'),
(12, 6, '�������'),
(13, 6, '��������'),
(14, 6, '�������������');

INSERT INTO `cities` (`ct_id`, `ct_name`) VALUES
(1, '������'),
(2, '�����'),
(3, '������'),
(4, '�����'),
(5, '������'),
(6, '����'),
(7, '�����'),
(8, '����'),
(9, '�������'),
(10, '������');

INSERT INTO `connections` (`cn_from`, `cn_to`, `cn_cost`, `cn_bidir`) VALUES
(1, 5, 10, 'Y'),
(1, 7, 20, 'N'),
(7, 1, 25, 'N'),
(7, 2, 15, 'Y'),
(2, 6, 50, 'N'),
(6, 8, 40, 'Y'),
(8, 4, 30, 'N'),
(4, 8, 35, 'N'),
(8, 9, 15, 'Y'),
(9, 1, 20, 'N'),
(7, 3, 5, 'N'),
(3, 6, 5, 'N');


INSERT INTO `shopping`
(
    `sh_id`,
    `sh_transaction`,
    `sh_category`
) VALUES
(1, 1, '�����'),
(2, 1, '������'),
(3, 1, '�����'),
(4, 2, '�����'),
(5, 2, '����'),
(6, 3, '������'),
(7, 3, '����'),
(8, 3, '�����'),
(9, 3, '������'),
(10, 4, '�����');