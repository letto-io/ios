import UIKit

class StringUtil {
    
    //refleshControl
    static let pullToRefresh = "Puxe para atualizar"
    
    //SegueIdentifier storyboard
    static let instructionView = "instructionView"
    
    //AlertView
    static let message = "Mensagem"
    static let ok = "OK"
    static let back = "VOLTAR"
    static let confirm = "CONFIRMAR"
    static let cancel = "CANCELAR"
    static let edit = "EDITAR"
    
    //requisições HTTP
    static let httpPOST = "POST"
    static let httpGET = "GET"
    static let httpDELETE = "DELETE"
    static let httpApplication = "application/json"
    static let httpHeader = "Content-Type"
    static let set_Cookie = "Set-Cookie"
     static let sessionToken = "x-session-token"
    static let key_Value = "key=value"
    static let value = "value"
    static let error = "error"
    static let error404 = "Erro 404"
    static let error401 = "Erro 401"
    
    //nibNames cell
    static let cellIdentifier = "cell"
    static let disciplineCell = "DisciplineCell"
    static let presentationCell = "PresentationCell"
    static let doubtCell = "DoubtTableViewCell"
    static let doubtResponseCell = "DoubtResponseTableViewCell"
    
    
    
    //mensagens de AlertView de ViewController.swift
        static let msgEmailPasswordRequired = "Email e Senha são obrigatórios"
        static let msgEmailRequired = "Email é obrigatório"
        static let msgPasswordRequired = "Senha é obrigatório"
        static let msgEmailPasswordIncorrect = "Email ou Senha incorretos"
    
        //JSON Object
        static let jsEmail = "email"
        static let jsPassord = "password"
        static let jsText = "text"
        static let jsAnonymous = "anonymous"
    
    //InstructionViewController
        static let InstructionViewController = "InstructionViewController"
        static let titleDiscipline = "Disciplinas"
        static let lectures = "lectures"
        static let lecture = "lecture"
        static let event = "event"
        static let code = "code"
        static let name = "name"
        static let id = "id"
        static let workload = "workload"
        static let start_date = "start_date"
        static let end_date = "end_date"
        static let class_number = "class_number"
        static let profile  = "profile"
        static let turma = "Turma: "
        static let start = "Início: "
    
    //PresentationsTabBarController.swift
        static let presentationsTabBarController = "PresentationsTabBarController"
        static let titlePresentasation = "Apresentações"
        static let open = "ABERTAS"
        static let closed = "FECHADAS"
        static let all = "TODAS"
        static let ranking = "RANKING"
    
    //DoubtTabBarController.swift
        static let doubtTabBarViewController = "DoubtTabBarViewController"
        static let doubtTitle = "Dúvidas"
    
    //OpenPresentationViewController.swift e ClosedPresentationViewController.swift
        static let openPresentationViewController = "OpenPresentationViewController"
        static let closedPresentationViewController = "ClosedPresentationViewController"
        static let msgNoPresentation = "Sem apresentações"
        static let msgClosePresentation = "Fechar apresentação?"
        static let presentations = "presentations"
        static let person = "person"
        static let createdat = "createdat"
        static let status = "status"
        static let subject  = "subject"
        static let instruction = "instruction"
    
    
    //CreateNewPresentationViewController.swift
        static let createNewPresentationViewController = "CreateNewPresentationViewController"
        static let newPresentationTitle = "Nova Apresentação"
        static let msgSubjectRequired = "Tema é obrigatório"
        static let msgErrorRequest = "Não foi possível completar sua requisição!"
        static let msgNewPresentationSuccess = "Apresentação cadastrada com sucesso"
        static let msgNewPresentationConfirm = "Deseja confimar?"
    
    
    //QuestionViewController
        static let QuestionViewController = "QuestionViewController"
        static let OpenQuestionViewController = "OpenQuestionViewController"
        static let ClosedQuestionViewController = "ClosedQuestionViewController"
        static let rankingDoubtViewController = "RankingDoubtViewController"
        static let msgNoDoubt = "Sem dúvidas na apresentação"
        static let answers = "answers"
        static let accepted = "accepted"
        static let upvotes = "upvootes"
        static let downvotes = "downvotes"
        static let my_vote = "my_vote"
        static let answered = "answered"
        static let has_answer = "has_answer"
        static let contributions = "contributions"
        static let likes = "likes"
        static let presentation = "presentation"
        static let text = "text"
        static let anonymous = "anonymous"
        static let like = "like"
        static let anonimo = "Anônimo"
        static let entendi = "ENTENDI"
        static let msgNotRankYourDoubt = "Você não pode ranquear sua propria dúvida!"
    
    //RecoverPasswordViewController.swift
        static let msgEmailNotFound = "Email não encontrado"
        static let msgInvalidEmail = "Email inválido"
        static let msgSendEmail = "Mensagem encaminhada ao Email"
    
    //RegisterViewController
        static let msgAllRequired = "Todos os campos são obrigatórios"
        static let msgPasswordNotMatch = "Senhas não correspodem"
    
    //CreateNewDoubtViewController.swift
        static let createNewDoubtViewController = "CreateNewDoubtViewController"
        static let newDoubtTitle = "Nova Dúvida"
        static let msgDoubtTextRequired = "Descreva sua dúvida"
        static let msgNewDoubtConfirm = "Deseja confimar?"
        static let msgNewDoubtSuccess = "Dúvida cadastrada com sucesso"
    
    
    //DoubtsResponseTabBarViewController.swif
    static let doubtsResponseTabBarViewController = "DoubtsResponseTabBarViewController"
    static let Texto = "Texto"
    static let Audio = "Audio"
    static let Video = "Video"
    static let Galeria = "Galeria"
    static let Foto = "Foto"
    static let newContribution = "Nova Contribuição"
    static let galery = "galery"
    
    //TextDoubtReponseViewController.swift
    static let textDoubtReponseViewController = "TextDoubtReponseViewController"
    static let mcmaterial = "mcmaterial"
    static let mime = "mime"
    static let msgNoContributions = "Não há contribuições"
    
    
    //AudioDoubtResponseViewController
    static let AudioDoubtResponseViewController = "AudioDoubtResponseViewController"
    static let audio = "audio"
    
    //VideoDoubtResponseViewController
    static let VideoDoubtResponseViewController = "VideoDoubtResponseViewController"
    static let video = "video"
    
    //AttachmentDoubtResponseViewController
    static let AttachmentDoubtResponseViewController = "AttachmentDoubtResponseViewController"
    static let image = "image"
    static let applicationPdf = "application/pdf"
    static let Anexo = "Anexo"
    static let fileName = "Nova contribuição"
    static let fileNameEmpty = "Por favor digite o nome do arquivo!"
    static let cameraNotAccess = "Aplicação não pode acessar a camera"

    
    //Login
    static let login_id = "id"
    static let created_at = "created_at"
    static let token = "token"
    static let user_id = "user_id"
    static let user = "user"
    static let email = "email"
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}